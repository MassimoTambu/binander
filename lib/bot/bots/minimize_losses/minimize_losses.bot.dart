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
  BotStatus status = BotStatus(BotPhases.offline, 'offline');

  @JsonKey(ignore: true)
  WidgetRef? ref;
  @JsonKey(ignore: true)
  Timer? timer;

  double? buyOrderPrice;
  bool isBuyOrderCompleted = false;
  double? lastSellOrderPrice;
  int? sellOrderId;
  double lossSellOrderCounter = 0;
  dynamic? cryptoInfo;

  MinimizeLossesBot(this.name, this.testNet, this.config);

  MinimizeLossesBot.create({
    required this.name,
    required this.testNet,
    required String symbol,
    required int dailyLossSellOrders,
    required double maxInvestmentPerOrder,
    required double percentageSellOrder,
    required Duration timerBuyOrder,
  }) {
    uuid = const Uuid().v4();
    type = BotTypes.minimizeLosses;
    config = MinimizeLossesConfig.create(
      symbol: symbol,
      dailyLossSellOrders: dailyLossSellOrders,
      maxInvestmentPerOrder: maxInvestmentPerOrder,
      percentageSellOrder: percentageSellOrder,
      timerBuyOrder: timerBuyOrder,
    );
  }

  @override
  void start(WidgetRef ref) async {
    this.ref = ref;

    changeStatusTo(BotPhases.starting, 'starting');

    if (timer != null) timer!.cancel();

    // If buyorder does not exists
    if (buyOrderPrice == null) {
      await _getCurrentCryptoPrice();

      // Exit if bot execution has been interrupted
      if (status.phase != BotPhases.starting) return;

      changeStatusTo(BotPhases.starting, 'submitting buy order');

      // submit order price
      await _submitBuyOrder();
    }

    // Exit if bot execution has been interrupted
    if (status.phase != BotPhases.starting) return;

    changeStatusTo(BotPhases.starting, 'waiting buy order to complete');

    timer =
        Timer.periodic(const Duration(seconds: 10), _runCheckBuyOrderPipeline);
  }

  @override
  void stop(WidgetRef ref, {String reason = ''}) async {
    timer?.cancel();

    if (reason.isNotEmpty) {
      reason = ': $reason';
    }

    /// TODO check and remove Buy Order

    changeStatusTo(BotPhases.stopping, 'stopping' + reason);

    await Future.delayed(const Duration(seconds: 4));

    changeStatusTo(BotPhases.offline, 'turned off' + reason);

    /// TODO notify
  }

  @override
  void remove(WidgetRef ref) {
    /// TODO implement remove
  }

  factory MinimizeLossesBot.fromJson(Map<String, dynamic> json) =>
      _$MinimizeLossesBotFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MinimizeLossesBotToJson(this);

  void changeStatusTo(BotPhases phase, String message) {
    status = BotStatus(phase, message);
    ref?.read(botProvider.notifier).updateBotStatus(uuid, status);
  }

  Future<void> _runCheckBuyOrderPipeline(Timer timer) async {
    if (!timer.isActive) return;
    // Exit if bot execution has been interrupted
    if (status.phase != BotPhases.starting) return;

    final buyOrderStatus = await _checkBuyOrderStatus();

    if (buyOrderStatus == 'completed') {
      timer.cancel();

      changeStatusTo(BotPhases.online, 'online');

      timer = Timer.periodic(const Duration(seconds: 10), _runBotPipeline);
    }
  }

  /// - fetch informazione sulla crypto ogni 10s
  /// - Fare in modo che il bot aumenti l'ordine di vendita piazzando un ordine con un valore ricavato da questa formula:
  /// (prezzo_attuale - (calcolo della % impostata verso il prezzo_iniziale)) > last_prezzo_ordine
  /// - Memorizzare se l'ordine eseguito è risultato una perdita o un profitto.
  /// - Controllare all'avvio se è presente un ordine in corso che è stato piazzato dall'ultimo avvio e ancora non si è concluso.
  Future<void> _runBotPipeline(Timer timer) async {
    if (!timer.isActive) return;

    if (sellOrderId == null) {
      await _submitSellOrder();
      return;
    }

    final sellOrder = await _getSellOrder();
    await _getCurrentCryptoPrice();

    // if order status is open or partially closed
    if (sellOrder.status == OrderStatus.NEW ||
        sellOrder.status == OrderStatus.PARTIALLY_FILLED) {
      if (_hasToMoveOrder()) {
        await _moveOrder();
        //TODO notify order moved
      }

      return;
    }
    // if order status is closed
    else if (sellOrder.status == OrderStatus.FILLED) {
      sellOrderId = null;

      /// TODO implement
      if (sellOrder == 'is a loss') {
        // add to loss counter
        lossSellOrderCounter += 1;

        /// TODO transform lossSellOrderCounter to dailyLossSellOrderCounter
        // check if is major or equal to loss counter
        if (lossSellOrderCounter >= config.dailyLossSellOrders!) {
          timer.cancel();
          return stop(ref!, reason: 'Daily loss sell orders reached');
        }
      }

      /// TODO write sellOrder to bot history order

    } else {
      /// TODO throw error
    }
  }

  Future<dynamic> _getCurrentCryptoPrice() {
    //TODO implement _getCurrentCryptoPrice
    return Future.delayed(const Duration(seconds: 1));
  }

  Future<dynamic> _submitBuyOrder() {
    //TODO implement _submitBuyOrder
    return Future.delayed(const Duration(seconds: 1));
  }

  Future<dynamic> _checkBuyOrderStatus() {
    //TODO implement _checkBuyOrderStatus
    return Future.delayed(const Duration(seconds: 1));
  }

  Future<dynamic> _submitSellOrder() {
    //TODO implement _submitSellOrder
    return Future.delayed(const Duration(seconds: 1));
  }

  Future<dynamic> _getSellOrder() {
    //TODO implement _getSellOrder
    return Future.delayed(const Duration(seconds: 1));
  }

  Future<dynamic> _moveOrder() {
    //TODO implement _moveOrder
    return Future.delayed(const Duration(seconds: 1));
  }

  bool _hasToMoveOrder() {
    return _calculateNewOrderPrice() > lastSellOrderPrice!;
  }

  double _calculateNewOrderPrice() {
    return cryptoInfo.actualValue -
        (buyOrderPrice! * config.percentageSellOrder! / 100);
  }
}
