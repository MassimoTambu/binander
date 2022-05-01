part of minimize_losses_bot;

@freezed
class MinimizeLossesPipeline with _$MinimizeLossesPipeline implements Pipeline {
  const MinimizeLossesPipeline._();

  const factory MinimizeLossesPipeline(Ref ref, MinimizeLossesBot bot) =
      _MinimizeLossesPipeline;

  @override
  void start() async {
    _incrementPipelineCounter();
    var timer = bot.pipelineData.timer;

    // We can't create a status variable because with freezed
    //  if the state changes (like below) we will have the old reference
    // final status = bot.pipelineData.status;

    if (timer != null && !timer.isActive) return;

    changeStatusTo(BotPhases.starting, 'starting');

    if (timer != null) timer.cancel();

    final botLimits = _getBotLimitsReached();
    if (botLimits.isNotEmpty) {
      changeStatusTo(
          BotPhases.error, botLimits.map((l) => l.cause).join(" - "));
      return;
    }

    final lastBuyOrder = bot.pipelineData.lastBuyOrder;
    // If buyorder does not exists
    if (lastBuyOrder == null) {
      bot.pipelineData.lastAveragePrice = await _getCurrentCryptoPrice();

      // Exit if bot execution has been interrupted
      if (bot.pipelineData.status.phase != BotPhases.starting) return;

      changeStatusTo(BotPhases.starting, 'submitting buy order');

      final accInfo = await _getAccountInformation();
      final accBalances = accInfo.balances.where(
        (b) => b.asset == bot.config.symbol!.rightPair,
      );
      // Asset not found in account
      if (accBalances.isEmpty) {
        return stop(reason: 'Asset not found on account');
      }

      final double rightPairQty = getRightPairQty(accBalances.first);

      await _trySubmitBuyOrder(rightPairQty);
      bot.pipelineData.buyOrderStartedAt = clock.now();
    }

    // Exit if bot execution has been interrupted
    if (bot.pipelineData.status.phase != BotPhases.starting) return;

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

    if (reason.isNotEmpty) {
      reason = ': $reason';
    }

    changeStatusTo(BotPhases.stopping, 'stopping' + reason);

    // We should leave a clean environment before stopping the bot.
    // If for some reason the bot has going to stop we should cancel the opened orders
    final lastBuyOrder = bot.pipelineData.lastBuyOrder;
    if (lastBuyOrder != null && lastBuyOrder.status != OrderStatus.FILLED) {
      await _cancelOrder(lastBuyOrder.orderId);
    }
    final lastSellOrder = bot.pipelineData.lastSellOrder;
    if (lastSellOrder != null && lastSellOrder.status != OrderStatus.FILLED) {
      await _cancelOrder(lastSellOrder.orderId);
    }

    bot.pipelineData.buyOrderStartedAt = null;
    bot.pipelineData.lastBuyOrder = null;
    bot.pipelineData.lastSellOrder = null;

    final closingMessage = 'turned off' + reason;

    changeStatusTo(BotPhases.offline, closingMessage);

    _showSnackBar(closingMessage);
  }

  void changeStatusTo(BotPhases phase, String message) {
    final status = BotStatus(phase, message);
    ref.read(pipelineProvider.notifier).updateBotStatus(bot.uuid, status);
  }

  void _incrementPipelineCounter() {
    bot.pipelineData.pipelineCounter += 1;
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
    _incrementPipelineCounter();
    if (!timer.isActive) return;
    // Exit if bot execution has been interrupted
    if (bot.pipelineData.status.phase != BotPhases.starting) return;

    final expireDate =
        bot.pipelineData.buyOrderStartedAt!.add(bot.config.timerBuyOrder!);
    final dateNow = clock.now();

    if (dateNow.isAfter(expireDate)) {
      // Should retry and submit another buy order
      changeStatusTo(BotPhases.starting,
          "buy order time limit reached. I'm about to try again..");

      await _cancelOrder(bot.pipelineData.lastBuyOrder!.orderId);
      bot.pipelineData.lastBuyOrder = null;
      bot.pipelineData.buyOrderStartedAt = null;
      timer.cancel();

      bot.pipelineData.timer =
          Timer.periodic(const Duration(seconds: 2), (_) => start());
      return;
    }

    // Update order status
    final buyOrderData = await _getBuyOrder();
    bot.pipelineData.lastBuyOrder = bot.pipelineData.lastBuyOrder!.copyWith(
      clientOrderId: buyOrderData.clientOrderId,
      cummulativeQuoteQty: buyOrderData.cummulativeQuoteQty,
      executedQty: buyOrderData.executedQty,
      orderId: buyOrderData.orderId,
      orderListId: buyOrderData.orderListId,
      origQty: buyOrderData.origQty,
      price: buyOrderData.price,
      side: buyOrderData.side,
      symbol: buyOrderData.symbol,
      status: buyOrderData.status,
      timeInForce: buyOrderData.timeInForce,
      type: buyOrderData.type,
    );

    if (bot.pipelineData.lastBuyOrder!.status == OrderStatus.FILLED) {
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
    _incrementPipelineCounter();
    if (!timer.isActive) return;

    bot.pipelineData.lastAveragePrice = await _getCurrentCryptoPrice();

    if (bot.pipelineData.lastSellOrder == null) {
      await _trySubmitSellOrder();
      changeStatusTo(BotPhases.online, 'submitted sell order');
      return;
    }

    changeStatusTo(BotPhases.online, 'pipeline has been started');

    final sellOrder = await _getSellOrder();
    bot.pipelineData.lastSellOrder = bot.pipelineData.lastSellOrder!.copyWith(
      clientOrderId: sellOrder.clientOrderId,
      cummulativeQuoteQty: sellOrder.cummulativeQuoteQty,
      executedQty: sellOrder.executedQty,
      orderId: sellOrder.orderId,
      orderListId: sellOrder.orderListId,
      origQty: sellOrder.origQty,
      price: sellOrder.price,
      side: sellOrder.side,
      symbol: sellOrder.symbol,
      status: sellOrder.status,
      timeInForce: sellOrder.timeInForce,
      type: sellOrder.type,
    );

    // if order status is open or partially closed
    if (sellOrder.status == OrderStatus.NEW ||
        //TODO find a solution for PARTIALLY_FILLED: it could probably break a lot of things
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
      final ordersPair = OrdersPair(
          buyOrder: bot.pipelineData.lastBuyOrder!, sellOrder: sellOrder);
      bot.pipelineData.ordersHistory.orders.add(ordersPair);

      var reason = 'Sell order executed';

      // Check if is a loss
      if (!ordersPair.isProfit) {
        // add to loss counter
        bot.pipelineData.lossSellOrderCounter += 1;

        /// TODO transform lossSellOrderCounter to dailyLossSellOrderCounter
        // check if is major or equal to loss counter
        if (_hasReachDailySellLossLimit()) {
          reason += ' - Daily loss sell orders reached';
        }
      }

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

  Future<AccountInformation> _getAccountInformation() async {
    final res = await ref
        .read(apiProvider)
        .spot
        .trade
        .getAccountInformation(_getApiConnection());
    return res.body;
  }

  double getRightPairQty(AccountBalance balance) {
    if (bot.config.maxInvestmentPerOrder! > balance.free) {
      return balance.free;
    }
    return bot.config.maxInvestmentPerOrder!;
  }

  Future<void> _trySubmitBuyOrder(double rightPairQty) async {
    try {
      bot.pipelineData.lastBuyOrder = await _submitBuyOrder(rightPairQty);
    } on ApiException catch (_, __) {
      const message = 'Failed to submit buy order. Retry in 10s';

      changeStatusTo(BotPhases.starting, message);

      _showSnackBar(message);

      bot.pipelineData.timer?.cancel();
      bot.pipelineData.timer = Timer(const Duration(seconds: 10), start);
    }
  }

  /// Submit a new Buy Order with the last average price approximated
  Future<OrderNew> _submitBuyOrder(double rightPairQty) async {
    final currentApproxPrice =
        _approxPrice(bot.pipelineData.lastAveragePrice!.price);
    final res = await ref.read(apiProvider).spot.trade.newOrder(
        _getApiConnection(),
        bot.config.symbol!,
        OrderSides.BUY,
        OrderTypes.LIMIT,
        _calculateBuyOrderQuantity(rightPairQty, currentApproxPrice),
        currentApproxPrice);

    return res.body;
  }

  double _calculateBuyOrderQuantity(double rightPairQty, double currentPrice) {
    final qty = rightPairQty / currentPrice;
    return (qty * 100).floorToDouble() / 100;
  }

  Future<OrderData> _getBuyOrder() async {
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
        bot.pipelineData.lastBuyOrder!.executedQty,
        currentApproxPrice);
    return res.body;
  }

  Future<OrderData> _getSellOrder() async {
    final res = await ref.read(apiProvider).spot.trade.getQueryOrder(
        _getApiConnection(),
        bot.config.symbol!,
        bot.pipelineData.lastSellOrder!.orderId);
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
    final lastAveragePrice = bot.pipelineData.lastAveragePrice!;
    final lastBuyOrder = bot.pipelineData.lastBuyOrder!;
    return lastAveragePrice.price -
        (lastBuyOrder.price * bot.config.percentageSellOrder! / 100);
  }

  /// TODO put buy order price as parameter
  /// Approximate price's second number after comma to floor
  double _approxPrice(double price) {
    return (price * 100).floorToDouble() / 100;
  }

  bool _hasReachDailySellLossLimit() {
    return bot.pipelineData.lossSellOrderCounter >=
        bot.config.dailyLossSellOrders!;
  }
}
