part of minimize_losses_bot;

class MinimizeLossesBot implements Bot {
  @override
  late final MinimizeLossesConfig config;
  @override
  final String name;
  late final MinimizeLossesStrategy strategy;

  MinimizeLossesBot.create({
    required this.name,
    required int dailyLossSellOrders,
    required double maxInvestmentPerOrder,
    required double percentageSellOrder,
    required Duration timerBuyOrder,
  }) {
    config = MinimizeLossesConfig.create(
        dailyLossSellOrders: dailyLossSellOrders,
        maxInvestmentPerOrder: maxInvestmentPerOrder,
        percentageSellOrder: percentageSellOrder,
        timerBuyOrder: timerBuyOrder);
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
}
