part of bot;

class MinimizeLossesConfig implements Config {
  final int dailyLossSellOrders;
  final int maxInvestmentPerOrder;
  final int percentageSellOrder;
  final Duration timerBuyOrder;

  MinimizeLossesConfig(
      {required this.dailyLossSellOrders,
      required this.maxInvestmentPerOrder,
      required this.percentageSellOrder,
      required this.timerBuyOrder});

  @override
  // TODO: implement info
  Map<String, String> get info => throw UnimplementedError();
}
