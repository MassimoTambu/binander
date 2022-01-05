part of minimize_losses_bot;

@JsonSerializable()
class MinimizeLossesBot implements Bot {
  @override
  late final String uuid;
  @override
  late final BotTypes type;
  @override
  late final MinimizeLossesConfig config;
  @override
  final String name;
  @JsonKey(
    fromJson: MinimizeLossesStrategy.fromJson,
    toJson: MinimizeLossesStrategy.toJson,
  )
  late final MinimizeLossesStrategy strategy;

  MinimizeLossesBot(this.name, this.strategy, this.config);

  MinimizeLossesBot.create({
    required this.name,
    required int dailyLossSellOrders,
    required double maxInvestmentPerOrder,
    required double percentageSellOrder,
    required Duration timerBuyOrder,
  }) {
    uuid = const Uuid().v4();
    type = BotTypes.minimizeLosses;
    config = MinimizeLossesConfig.create(
      dailyLossSellOrders: dailyLossSellOrders,
      maxInvestmentPerOrder: maxInvestmentPerOrder,
      percentageSellOrder: percentageSellOrder,
      timerBuyOrder: timerBuyOrder,
    );
    strategy = MinimizeLossesStrategy.create();
  }

  @override
  void start() {
    //TODO notify with snackbar
    // _eventsService.emitter
    //     .emit(EventTypes.bot.name, _senderName, name + ' has started!');
  }

  @override
  void stop() {
    // _eventsService.emitter
    //     .emit(EventTypes.bot.name, _senderName, name + ' has stopped!');
  }

  factory MinimizeLossesBot.fromJson(Map<String, dynamic> json) =>
      _$MinimizeLossesBotFromJson(json);

  @override
  Bot fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() => _$MinimizeLossesBotToJson(this);
}
