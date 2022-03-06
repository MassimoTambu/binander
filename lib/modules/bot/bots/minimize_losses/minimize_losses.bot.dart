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
  late WidgetRef _ref;
  @override
  late final MinimizeLossesPipeline pipeline;
  @override
  final ordersHistory = const OrdersHistory([]);

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
    pipeline = MinimizeLossesPipeline(this);
  }

  @override
  void remove(WidgetRef ref) {
    /// TODO implement remove
  }

  factory MinimizeLossesBot.fromJson(Map<String, dynamic> json) =>
      _$MinimizeLossesBotFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MinimizeLossesBotToJson(this);
}
