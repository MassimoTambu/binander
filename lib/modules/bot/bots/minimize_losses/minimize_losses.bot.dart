part of minimize_losses_bot;

@JsonSerializable()
class MinimizeLossesBot implements Bot {
  @override
  late final String uuid;
  @override
  late final BotTypes type;
  @override
  late final bool testNet;
  @override
  late final MinimizeLossesConfig config;
  @override
  final String name;
  @override
  @JsonKey(ignore: true)
  late WidgetRef ref;
  @override
  final ordersHistory = const OrdersHistory([]);
  @override
  @JsonKey(ignore: true)
  BotStatus status = const BotStatus(BotPhases.offline, 'offline');

  @JsonKey(ignore: true)
  Timer? timer;
  @JsonKey(ignore: true)
  AveragePrice? lastAveragePrice;
  OrderNew? lastBuyOrder;
  OrderNew? lastSellOrder;
  int lossSellOrderCounter = 0;

  MinimizeLossesBot(this.name, this.testNet, this.config);

  MinimizeLossesBot.create({
    required this.name,
    required this.testNet,
    required String symbol,
    required int dailyLossSellOrders,
    required double maxQuantityPerOrder,
    required double percentageSellOrder,
    required Duration timerBuyOrder,
  }) {
    uuid = const Uuid().v4();
    type = BotTypes.minimizeLosses;
    config = MinimizeLossesConfig.create(
      symbol: symbol,
      dailyLossSellOrders: dailyLossSellOrders,
      maxQuantityPerOrder: maxQuantityPerOrder,
      percentageSellOrder: percentageSellOrder,
      timerBuyOrder: timerBuyOrder,
    );
  }

  @override
  void remove(WidgetRef ref) {
    /// TODO implement remove
  }

  @override
  void start(WidgetRef ref) async {
    if (timer != null && !timer!.isActive) return;

    this.ref = ref;

    changeStatusTo(BotPhases.starting, 'starting');

    if (timer != null) timer!.cancel();

    final botLimits = _getBotLimitsReached();
    if (botLimits.isNotEmpty) {
      changeStatusTo(BotPhases.error, botLimits.first.cause);
      return;
    }

    // If buyorder does not exists
    if (lastBuyOrder == null) {
      lastAveragePrice = await _getCurrentCryptoPrice();

      // Exit if bot execution has been interrupted
      if (status.phase != BotPhases.starting) return;

      changeStatusTo(BotPhases.starting, 'submitting buy order');

      await _trySubmitBuyOrder();
    }

    // Exit if bot execution has been interrupted
    if (status.phase != BotPhases.starting) return;

    // ref.read(fileStorageProvider).upsertBots([this]);

    // Skip buyOrder pipeline if it has been filled
    if (lastBuyOrder != null && lastBuyOrder!.status == OrderStatus.FILLED) {
      timer = Timer.periodic(const Duration(seconds: 10), _runBotPipeline);
      return;
    }

    changeStatusTo(BotPhases.starting, 'waiting buy order to complete');

    timer =
        Timer.periodic(const Duration(seconds: 10), _runCheckBuyOrderPipeline);
  }

  @override
  void stop(WidgetRef ref, {String reason = ''}) async {
    this.ref = ref;
    timer?.cancel();

    changeStatusTo(BotPhases.stopping, 'stopping' + reason);

    if (reason.isNotEmpty) {
      reason = ': $reason';
    }

    if (lastBuyOrder != null) {
      await _cancelOrder(lastBuyOrder!.orderId);
    }

    final closingMessage = 'turned off' + reason;

    changeStatusTo(BotPhases.offline, closingMessage);

    _showSnackBar(closingMessage);
  }

  void changeStatusTo(BotPhases phase, String message) {
    status = BotStatus(phase, message);
    ref.read(botProvider.notifier).updateBotStatus(uuid, status);
  }

  List<BotLimit> _getBotLimitsReached() {
    final limits = <BotLimit>[];
    if (_hasReachDailySellLossLimit()) {
      limits.add(BotLimit(
          'Daily sell loss limit reached, max ${config.dailyLossSellOrders}'));
    }

    return limits;
  }

  /// Check if buy order has been filled. If so, fetch run Bot Pipeline every 10s
  Future<void> _runCheckBuyOrderPipeline(Timer timer) async {
    if (!timer.isActive) return;
    // Exit if bot execution has been interrupted
    if (status.phase != BotPhases.starting) return;

    // Update order status
    lastBuyOrder!.copyWith(status: (await _getBuyOrder()).status);

    if (lastBuyOrder!.status == OrderStatus.FILLED) {
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

    lastAveragePrice = await _getCurrentCryptoPrice();

    if (lastSellOrder == null) {
      await _trySubmitSellOrder();
      changeStatusTo(BotPhases.online, 'submitted sell order');
      return;
    }

    changeStatusTo(BotPhases.online, 'pipeline has been started');

    final sellOrder = await _getSellOrder();

    print(_calculateNewOrderPrice());
    print(lastSellOrder!.price);
    print(lastSellOrder!.price);

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
      ordersHistory.add(buyOrder: buyOrder, sellOrder: sellOrder);

      lastBuyOrder = null;
      lastSellOrder = null;
      timer.cancel();

      // Check if is a loss
      if (sellOrder.executedQty < lastBuyOrder!.executedQty) {
        // add to loss counter
        lossSellOrderCounter += 1;

        /// TODO transform lossSellOrderCounter to dailyLossSellOrderCounter
        // check if is major or equal to loss counter
        if (_hasReachDailySellLossLimit()) {
          return stop(ref, reason: 'Daily loss sell orders reached');
        }
      }

      return stop(ref, reason: 'Sell order executed');
    } else {
      /// TODO throw error
    }
  }

  void _showSnackBar(String message) {
    ref.read(snackBarProvider).show(message);
  }

  ApiConnection _getApiConnection() {
    if (testNet) {
      return ref.read(settingsProvider).testNetConnection;
    }
    return ref.read(settingsProvider).pubNetConnection;
  }

  Future<AveragePrice> _getCurrentCryptoPrice() async {
    final res = await ref
        .read(apiProvider)
        .spot
        .market
        .getAveragePrice(_getApiConnection(), config.symbol!);
    return res.body;
  }

  Future<void> _trySubmitBuyOrder() async {
    try {
      lastBuyOrder = await _submitBuyOrder();
    } on ApiException catch (_, __) {
      const message = 'Failed to submit buy order. Retry in 10s';

      changeStatusTo(BotPhases.starting, message);

      _showSnackBar(message);

      timer?.cancel();
      timer = Timer(const Duration(seconds: 10), () => start(ref));
    }
  }

  /// Submit a new Buy Order with the last average price approximated
  Future<OrderNew> _submitBuyOrder() async {
    final currentApproxPrice = _approxPrice(lastAveragePrice!.price);
    final res = await ref.read(apiProvider).spot.trade.newOrder(
        _getApiConnection(),
        config.symbol!,
        OrderSides.BUY,
        OrderTypes.LIMIT,
        config.maxQuantityPerOrder!,
        currentApproxPrice);

    return res.body;
  }

  Future<Order> _getBuyOrder() async {
    final res = await ref.read(apiProvider).spot.trade.getQueryOrder(
        _getApiConnection(), config.symbol!, lastBuyOrder!.orderId);

    return res.body;
  }

  Future<void> _trySubmitSellOrder() async {
    try {
      lastSellOrder = await _submitSellOrder();
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
        config.symbol!,
        OrderSides.SELL,
        OrderTypes.LIMIT,
        config.maxQuantityPerOrder!,
        currentApproxPrice);
    return res.body;
  }

  Future<Order> _getSellOrder() async {
    final res = await ref.read(apiProvider).spot.trade.getQueryOrder(
        _getApiConnection(), config.symbol!, lastBuyOrder!.orderId);
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
        .cancelOrder(_getApiConnection(), config.symbol!, orderId);

    return res.body;
  }

  bool _hasToMoveOrder() {
    return _calculateNewOrderPrice() > lastSellOrder!.price;
  }

  double _calculateNewOrderPrice() {
    return lastAveragePrice!.price -
        (lastBuyOrder!.price * config.percentageSellOrder! / 100);
  }

  /// TODO put buy order price as parameter
  double _approxPrice(double price) {
    return price.floorToDouble();
  }

  bool _hasReachDailySellLossLimit() {
    return lossSellOrderCounter >= config.dailyLossSellOrders!;
  }

  factory MinimizeLossesBot.fromJson(Map<String, dynamic> json) =>
      _$MinimizeLossesBotFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MinimizeLossesBotToJson(this);
}
