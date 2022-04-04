part of minimize_losses_bot;

class MinimizeLossesPipeline implements Pipeline {
  @override
  final Ref ref;
  @override
  final MinimizeLossesBot bot;

  const MinimizeLossesPipeline(this.ref, this.bot);

  @override
  void start() async {
    var timer = bot.pipelineData.timer;
    final status = bot.pipelineData.status;
    if (timer != null && !timer.isActive) return;

    changeStatusTo(BotPhases.starting, 'starting');

    if (timer != null) timer.cancel();

    final botLimits = _getBotLimitsReached();
    if (botLimits.isNotEmpty) {
      changeStatusTo(BotPhases.error, botLimits.first.cause);
      return;
    }

    final lastBuyOrder = bot.pipelineData.lastBuyOrder;
    // If buyorder does not exists
    if (lastBuyOrder == null) {
      bot.pipelineData.lastAveragePrice = await _getCurrentCryptoPrice();

      // Exit if bot execution has been interrupted
      if (status.phase != BotPhases.starting) return;

      changeStatusTo(BotPhases.starting, 'submitting buy order');

      await _trySubmitBuyOrder();
    }

    // Exit if bot execution has been interrupted
    if (status.phase != BotPhases.starting) return;

    // ref.read(fileStorageProvider).upsertBots([this]);

    // Skip buyOrder pipeline if it has been filled
    if (lastBuyOrder != null && lastBuyOrder.status == OrderStatus.FILLED) {
      timer = Timer.periodic(const Duration(seconds: 10), _runBotPipeline);
      return;
    }

    changeStatusTo(BotPhases.starting, 'waiting buy order to complete');

    timer =
        Timer.periodic(const Duration(seconds: 10), _runCheckBuyOrderPipeline);
  }

  @override
  void stop({String reason = ''}) async {
    bot.pipelineData.timer?.cancel();

    changeStatusTo(BotPhases.stopping, 'stopping' + reason);

    if (reason.isNotEmpty) {
      reason = ': $reason';
    }

    final lastBuyOrder = bot.pipelineData.lastBuyOrder;
    if (lastBuyOrder != null) {
      await _cancelOrder(lastBuyOrder.orderId);
    }
    //TODO cancel sell order

    final closingMessage = 'turned off' + reason;

    changeStatusTo(BotPhases.offline, closingMessage);

    _showSnackBar(closingMessage);
  }

  void changeStatusTo(BotPhases phase, String message) {
    final status = BotStatus(phase, message);
    ref.read(pipelineProvider.notifier).updateBotStatus(bot.uuid, status);
  }

  List<BotLimit> _getBotLimitsReached() {
    final limits = <BotLimit>[];
    if (_hasReachDailySellLossLimit()) {
      limits.add(BotLimit(
          'Daily sell loss limit reached, max ${bot.config.dailyLossSellOrders}'));
    }

    return limits;
  }

  /// Check if buy order has been filled. If so, fetch run Bot Pipeline every 10s
  Future<void> _runCheckBuyOrderPipeline(Timer timer) async {
    if (!timer.isActive) return;
    // Exit if bot execution has been interrupted
    if (bot.pipelineData.status.phase != BotPhases.starting) return;

    // Update order status
    final lastBuyOrder = bot.pipelineData.lastBuyOrder;
    lastBuyOrder!.copyWith(status: (await _getBuyOrder()).status);

    if (lastBuyOrder.status == OrderStatus.FILLED) {
      timer.cancel();

      changeStatusTo(BotPhases.online, 'buy order has been filled');

      timer = Timer.periodic(const Duration(seconds: 10), _runBotPipeline);
    }
  }

  /// - Fare in modo che il bot aumenti l'ordine di vendita piazzando un ordine con un valore ricavato da questa formula:
  /// (prezzo_attuale - (calcolo della % impostata verso il prezzo_iniziale)) > last_prezzo_ordine
  /// - Memorizzare se l'ordine eseguito è risultato una perdita o un profitto.
  /// - Controllare all'avvio se è presente un ordine in corso che è stato piazzato dall'ultimo avvio e ancora non si è concluso.
  Future<void> _runBotPipeline(Timer timer) async {
    if (!timer.isActive) return;

    bot.pipelineData.lastAveragePrice = await _getCurrentCryptoPrice();

    final lastSellOrder = bot.pipelineData.lastSellOrder;
    if (lastSellOrder == null) {
      await _trySubmitSellOrder();
      changeStatusTo(BotPhases.online, 'submitted sell order');
      return;
    }

    changeStatusTo(BotPhases.online, 'pipeline has been started');

    final sellOrder = await _getSellOrder();

    print(_calculateNewOrderPrice());
    print(lastSellOrder.price);
    print(lastSellOrder.price);

    // if order status is open or partially closed
    if (sellOrder.status == OrderStatus.NEW ||
        sellOrder.status == OrderStatus.PARTIALLY_FILLED) {
      if (_hasToMoveOrder()) {
        await _moveOrder(sellOrder.orderId);
        //TODO notify order moved
      }

      return;
    }
    // if order status is closed
    else if (sellOrder.status == OrderStatus.FILLED) {
      // TODO resume a buy order
      final buyOrder = await _getBuyOrder();
      bot.pipelineData.ordersHistory
          .add(buyOrder: buyOrder, sellOrder: sellOrder);

      var reason = 'Sell order executed';

      // Check if is a loss
      if (sellOrder.executedQty < bot.pipelineData.lastBuyOrder!.executedQty) {
        // add to loss counter
        bot.pipelineData.lossSellOrderCounter += 1;

        /// TODO transform lossSellOrderCounter to dailyLossSellOrderCounter
        // check if is major or equal to loss counter
        if (_hasReachDailySellLossLimit()) {
          reason = 'Daily loss sell orders reached';
        }
      }

      bot.pipelineData.lastBuyOrder = null;
      bot.pipelineData.lastSellOrder = null;
      timer.cancel();

      return stop(reason: reason);
    } else {
      /// TODO throw error
    }
  }

  void _showSnackBar(String message) {
    ref.read(snackBarProvider).show(message);
  }

  ApiConnection _getApiConnection() {
    if (bot.testNet) {
      return ref.read(settingsProvider).testNetConnection;
    }
    return ref.read(settingsProvider).pubNetConnection;
  }

  Future<AveragePrice> _getCurrentCryptoPrice() async {
    final res = await ref
        .read(apiProvider)
        .spot
        .market
        .getAveragePrice(_getApiConnection(), bot.config.symbol!);
    return res.body;
  }

  Future<void> _trySubmitBuyOrder() async {
    try {
      bot.pipelineData.lastBuyOrder = await _submitBuyOrder();
    } on ApiException catch (_, __) {
      const message = 'Failed to submit buy order. Retry in 10s';

      changeStatusTo(BotPhases.starting, message);

      _showSnackBar(message);

      bot.pipelineData.timer?.cancel();
      bot.pipelineData.timer = Timer(const Duration(seconds: 10), start);
    }
  }

  /// Submit a new Buy Order with the last average price approximated
  Future<OrderNew> _submitBuyOrder() async {
    final currentApproxPrice =
        _approxPrice(bot.pipelineData.lastAveragePrice!.price);
    final res = await ref.read(apiProvider).spot.trade.newOrder(
        _getApiConnection(),
        bot.config.symbol!,
        OrderSides.BUY,
        OrderTypes.LIMIT,
        bot.config.maxQuantityPerOrder!,
        currentApproxPrice);

    return res.body;
  }

  Future<Order> _getBuyOrder() async {
    final res = await ref.read(apiProvider).spot.trade.getQueryOrder(
        _getApiConnection(),
        bot.config.symbol!,
        bot.pipelineData.lastBuyOrder!.orderId);

    return res.body;
  }

  Future<void> _trySubmitSellOrder() async {
    try {
      bot.pipelineData.lastSellOrder = await _submitSellOrder();
    } on ApiException catch (_, __) {
      const message = 'Failed to submit sell order';

      changeStatusTo(BotPhases.starting, message);

      _showSnackBar(message);
    }
  }

  Future<OrderNew> _submitSellOrder() async {
    final currentApproxPrice = _approxPrice(_calculateNewOrderPrice());

    final res = await ref.read(apiProvider).spot.trade.newOrder(
        _getApiConnection(),
        bot.config.symbol!,
        OrderSides.SELL,
        OrderTypes.LIMIT,
        bot.config.maxQuantityPerOrder!,
        currentApproxPrice);
    return res.body;
  }

  Future<Order> _getSellOrder() async {
    final res = await ref.read(apiProvider).spot.trade.getQueryOrder(
        _getApiConnection(),
        bot.config.symbol!,
        bot.pipelineData.lastBuyOrder!.orderId);
    return res.body;
  }

  Future<void> _moveOrder(int orderId) async {
    await _cancelOrder(orderId);
    await _trySubmitSellOrder();
  }

  Future<OrderCancel> _cancelOrder(int orderId) async {
    final res = await ref
        .read(apiProvider)
        .spot
        .trade
        .cancelOrder(_getApiConnection(), bot.config.symbol!, orderId);

    return res.body;
  }

  bool _hasToMoveOrder() {
    return _calculateNewOrderPrice() > bot.pipelineData.lastSellOrder!.price;
  }

  double _calculateNewOrderPrice() {
    final lastAveragePrice = bot.pipelineData.lastAveragePrice;
    final lastBuyOrder = bot.pipelineData.lastBuyOrder;
    return lastAveragePrice!.price -
        (lastBuyOrder!.price * bot.config.percentageSellOrder! / 100);
  }

  /// TODO put buy order price as parameter
  double _approxPrice(double price) {
    return price.floorToDouble();
  }

  bool _hasReachDailySellLossLimit() {
    return bot.pipelineData.lossSellOrderCounter >=
        bot.config.dailyLossSellOrders!;
  }
}