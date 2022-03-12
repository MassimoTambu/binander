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
  BotStatus status = BotStatus(BotPhases.offline, 'offline');

  @JsonKey(ignore: true)
  Timer? timer;
  AveragePrice? lastAveragePrice;
  OrderNew? lastBuyOrder;
  bool isBuyOrderCompleted = false;
  OrderNew? lastSellOrder;
  double lossSellOrderCounter = 0;

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
    this.ref = ref;

    changeStatusTo(BotPhases.starting, 'starting');

    if (timer != null) timer!.cancel();

    // If buyorder does not exists
    if (lastBuyOrder == null) {
      lastAveragePrice = await _getCurrentCryptoPrice();

      // Exit if bot execution has been interrupted
      if (status.phase != BotPhases.starting) return;

      changeStatusTo(BotPhases.starting, 'submitting buy order');

      // submit order price
      lastBuyOrder = await _submitBuyOrder();
    }

    // Exit if bot execution has been interrupted
    if (status.phase != BotPhases.starting) return;

    changeStatusTo(BotPhases.starting, 'waiting buy order to complete');

    ref.read(fileStorageProvider).upsertBots([this]);

    timer =
        Timer.periodic(const Duration(seconds: 10), _runCheckBuyOrderPipeline);
  }

  @override
  void stop(WidgetRef ref, {String reason = ''}) async {
    this.ref = ref;
    timer?.cancel();

    if (reason.isNotEmpty) {
      reason = ': $reason';
    }

    if (lastBuyOrder != null) {
      await _cancelOrder(lastBuyOrder!.orderId);
    }

    changeStatusTo(BotPhases.stopping, 'stopping' + reason);

    await Future.delayed(const Duration(seconds: 4));

    changeStatusTo(BotPhases.offline, 'turned off' + reason);

    /// TODO notify
  }

  void changeStatusTo(BotPhases phase, String message) {
    status = BotStatus(phase, message);
    ref.read(botProvider.notifier).updateBotStatus(uuid, status);
  }

  /// Check if buy order has been filled. If so, fetch run Bot Pipeline every 10s
  Future<void> _runCheckBuyOrderPipeline(Timer timer) async {
    if (!timer.isActive) return;
    // Exit if bot execution has been interrupted
    if (status.phase != BotPhases.starting) return;

    final buyOrderStatus = await _checkBuyOrderStatus();

    if (buyOrderStatus == OrderStatus.FILLED) {
      timer.cancel();

      changeStatusTo(BotPhases.online, 'online');

      timer = Timer.periodic(const Duration(seconds: 10), _runBotPipeline);
    }
  }

  /// - Fare in modo che il bot aumenti l'ordine di vendita piazzando un ordine con un valore ricavato da questa formula:
  /// (prezzo_attuale - (calcolo della % impostata verso il prezzo_iniziale)) > last_prezzo_ordine
  /// - Memorizzare se l'ordine eseguito è risultato una perdita o un profitto.
  /// - Controllare all'avvio se è presente un ordine in corso che è stato piazzato dall'ultimo avvio e ancora non si è concluso.
  Future<void> _runBotPipeline(Timer timer) async {
    if (!timer.isActive) return;

    if (lastSellOrder == null) {
      lastSellOrder = await _submitSellOrder();
      return;
    }

    final sellOrder = await _getSellOrder();
    lastAveragePrice = await _getCurrentCryptoPrice();

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
      ordersHistory.add(sellOrder);
      lastSellOrder = null;

      // Check if is a loss
      if (sellOrder.executedQty < lastBuyOrder!.executedQty) {
        // add to loss counter
        lossSellOrderCounter += 1;

        /// TODO transform lossSellOrderCounter to dailyLossSellOrderCounter
        // check if is major or equal to loss counter
        if (lossSellOrderCounter >= config.dailyLossSellOrders!) {
          timer.cancel();
          return stop(ref, reason: 'Daily loss sell orders reached');
        }
      }
    } else {
      /// TODO throw error
    }
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

  Future<OrderStatus> _checkBuyOrderStatus() async {
    final res = await ref.read(apiProvider).spot.trade.getQueryOrder(
        _getApiConnection(), config.symbol!, lastBuyOrder!.orderId);

    return res.body.status;
  }

  Future<OrderNew> _submitSellOrder() async {
    //TODO implement _submitSellOrder
    final res = await ref.read(apiProvider).spot.trade.newOrder(
        _getApiConnection(),
        config.symbol!,
        OrderSides.SELL,
        OrderTypes.LIMIT,
        config.maxQuantityPerOrder!,
        lastBuyOrder!.executedQty);
    return res.body;
  }

  Future<Order> _getSellOrder() async {
    final res = await ref.read(apiProvider).spot.trade.getQueryOrder(
        _getApiConnection(), config.symbol!, lastBuyOrder!.orderId);
    return res.body;
  }

  Future<void> _moveOrder(int orderId) async {
    await _cancelOrder(orderId);
    lastSellOrder = await _submitSellOrder();
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
    return (price).floorToDouble();
  }

  factory MinimizeLossesBot.fromJson(Map<String, dynamic> json) =>
      _$MinimizeLossesBotFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MinimizeLossesBotToJson(this);
}
