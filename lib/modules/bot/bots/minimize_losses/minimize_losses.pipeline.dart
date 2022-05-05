part of minimize_losses_bot;

@freezed
class MinimizeLossesPipeline with _$MinimizeLossesPipeline implements Pipeline {
  const MinimizeLossesPipeline._();

  const factory MinimizeLossesPipeline(Ref ref, MinimizeLossesBot bot) =
      _MinimizeLossesPipeline;

  @override
  void start() async {
    var timer = bot.pipelineData.timer;

    // We can't create a status variable because with freezed
    //  if the state changes (like below) we will have the old reference
    // final status = bot.pipelineData.status;

    if (timer != null && !timer.isActive) return;

    _incrementPipelineCounter();

    changeStatusTo(BotPhases.starting, 'starting');

    if (timer != null) timer.cancel();

    final botLimits = _getBotLimitsReached();
    if (botLimits.isNotEmpty) {
      return shutdown(
          phase: BotPhases.error,
          reason: botLimits.map((l) => l.cause).join(" - "));
    }

    final lastBuyOrder = bot.pipelineData.lastBuyOrder;
    // If buyorder does not exists
    if (lastBuyOrder == null) {
      // Exit if bot execution has been interrupted
      if (bot.pipelineData.status.phase != BotPhases.starting) return;

      changeStatusTo(BotPhases.starting, 'submitting buy order');

      final accInfo = await _getAccountInformation();
      final accBalances = accInfo.balances.where(
        (b) => b.asset == bot.config.symbol!.rightPair,
      );
      // Asset not found in account
      if (accBalances.isEmpty) {
        return shutdown(
            phase: BotPhases.error,
            reason: 'asset not found on wallet account');
      }

      bot.pipelineData.lastAveragePrice = await _getCurrentCryptoPrice();

      final double rightPairQty = getRightPairQty(accBalances.first);

      await _trySubmitBuyOrder(rightPairQty);
      bot.pipelineData.buyOrderStartedAt = clock.now();
    }

    // Exit if bot execution has been interrupted
    if (bot.pipelineData.status.phase != BotPhases.starting) return;

    // Skip buyOrder pipeline if it has been filled
    if (lastBuyOrder != null && lastBuyOrder.status == OrderStatus.FILLED) {
      changeStatusTo(BotPhases.online, 'resumed');
      timer = Timer.periodic(const Duration(seconds: 10), _runBotPipeline);
      return;
    }

    changeStatusTo(BotPhases.starting, 'waiting buy order to complete');

    timer =
        Timer.periodic(const Duration(seconds: 10), _runCheckBuyOrderPipeline);
  }

  @override
  void pause() {
    bot.pipelineData.timer?.cancel();

    const message = 'Paused by user';

    changeStatusTo(BotPhases.offline, message);

    _showSnackBar(message);
  }

  @override
  void shutdown(
      {BotPhases phase = BotPhases.offline, String reason = ''}) async {
    bot.pipelineData.timer?.cancel();

    if (reason.isNotEmpty) {
      reason = ': $reason';
    }

    changeStatusTo(BotPhases.stopping, 'stopping' + reason);

    // We should leave a clean environment before stopping the bot.
    // If for some reason the bot has going to stop we should cancel the opened orders
    final lastBuyOrder = bot.pipelineData.lastBuyOrder;
    if (lastBuyOrder != null && lastBuyOrder.status != OrderStatus.FILLED) {
      await _trySubmitCancelOrder(lastBuyOrder.orderId);
    }
    final lastSellOrder = bot.pipelineData.lastSellOrder;
    if (lastSellOrder != null && lastSellOrder.status != OrderStatus.FILLED) {
      await _trySubmitCancelOrder(lastSellOrder.orderId);
    }

    bot.pipelineData.buyOrderStartedAt = null;
    bot.pipelineData.lastBuyOrder = null;
    bot.pipelineData.lastSellOrder = null;

    final closingMessage = 'Turned off' + reason;

    changeStatusTo(phase, closingMessage);

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
    // Exit if bot execution has been interrupted
    if (!timer.isActive ||
        bot.pipelineData.status.phase != BotPhases.starting) {
      timer.cancel();
      return;
    }
    _incrementPipelineCounter();

    final expireDate =
        bot.pipelineData.buyOrderStartedAt!.add(bot.config.timerBuyOrder!);
    final dateNow = clock.now();

    if (dateNow.isAfter(expireDate)) {
      // Should retry and submit another buy order
      changeStatusTo(BotPhases.starting,
          "buy order time limit reached. I'm about to try again..");

      await _trySubmitCancelOrder(bot.pipelineData.lastBuyOrder!.orderId);
      bot.pipelineData.lastBuyOrder = null;
      bot.pipelineData.buyOrderStartedAt = null;
      timer.cancel();

      bot.pipelineData.timer =
          Timer.periodic(const Duration(seconds: 2), (_) => start());
      return;
    }

    // Update order status
    bot.pipelineData.lastBuyOrder = await _getBuyOrder();

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
    // Exit if bot execution has been interrupted
    if (!timer.isActive || bot.pipelineData.status.phase != BotPhases.online) {
      timer.cancel();
      return;
    }
    _incrementPipelineCounter();

    bot.pipelineData.lastAveragePrice = await _getCurrentCryptoPrice();

    if (bot.pipelineData.lastSellOrder == null) {
      await _trySubmitSellOrder();
      changeStatusTo(BotPhases.online, 'submitted sell order');
      return;
    }

    changeStatusTo(BotPhases.online, 'pipeline has been started');

    final sellOrder = await _getSellOrder();
    bot.pipelineData.lastSellOrder = sellOrder;

    // if order status is open or partially closed
    if (sellOrder.status == OrderStatus.NEW ||
        //TODO find a solution for PARTIALLY_FILLED: it could probably break a lot of things
        sellOrder.status == OrderStatus.PARTIALLY_FILLED) {
      if (_hasToMoveOrder()) {
        await _moveOrder(sellOrder.orderId);
        _showSnackBar(
            'Moved sell order to ${sellOrder.price} ${bot.config.symbol!.rightPair}');
      }

      return;
    }
    // If order status is closed
    else if (sellOrder.status == OrderStatus.FILLED) {
      // TODO resume a buy order
      final buyOrder = await bot.pipelineData.lastBuyOrder!.maybeMap(
          orderData: (orderData) => Future.value(orderData),
          orElse: () => _getBuyOrder());
      final sellOrder = await bot.pipelineData.lastSellOrder!.maybeMap(
          orderData: (orderData) => Future.value(orderData),
          orElse: () => _getSellOrder());

      final ordersPair = OrdersPair(buyOrder: buyOrder, sellOrder: sellOrder);
      bot.pipelineData.ordersHistory.orderPairs.add(ordersPair);

      var reason = 'Sell order executed';

      // Check if is a loss
      if (!ordersPair.isProfit) {
        // check if is major or equal to loss counter
        if (_hasReachDailySellLossLimit()) {
          reason += ' - Daily loss sell orders reached';
        }
      }

      timer.cancel();

      return shutdown(reason: reason);
    } else {
      // Unexpected order status:
      // CANCELED | EXPIRED | PARTIALLY_FILLED | PENDING_CANCEL | REJECTED
      // Bot will be turned off
      return shutdown(
          reason:
              'Unexpected order status: ${sellOrder.status.name}. Bot will be turned off..');
    }
  }

  void _showSnackBar(String message) {
    // Add bot name to message
    message = '${bot.name} - $message';
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
      final message = '${bot.name} - Failed to submit sell order';

      changeStatusTo(BotPhases.error, message);

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
    await _trySubmitCancelOrder(orderId);
    await _trySubmitSellOrder();
  }

  Future<void> _trySubmitCancelOrder(int orderId) async {
    try {
      final orderCancel = await _submitCancelOrder(orderId);
      final ordersPair = OrdersPair(buyOrder: orderCancel, sellOrder: null);
      bot.pipelineData.ordersHistory.ordersCancelled.add(ordersPair);
    } on ApiException catch (_, __) {
      const message = 'Failed to submit cancel order';

      changeStatusTo(BotPhases.error, message);

      _showSnackBar(message);
    }
  }

  Future<OrderCancel> _submitCancelOrder(int orderId) async {
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

  /// Approximate price's second number after comma to floor
  double _approxPrice(double price) {
    return (price * 100).floorToDouble() / 100;
  }

  bool _hasReachDailySellLossLimit() {
    final sellOrdersExecutedToday =
        bot.pipelineData.ordersHistory.lossesOnly.where(
      (o) {
        final dateTime = o.sellOrder?.map(
          orderData: (dataOrder) => dataOrder.updateTime,
          orderNew: (_) => null,
          orderCancel: (_) => null,
        );

        if (dateTime == null) return false;

        return dateTime.isSameDate(DateTime.now());
      },
    );

    return sellOrdersExecutedToday.length >= bot.config.dailyLossSellOrders!;
  }
}
