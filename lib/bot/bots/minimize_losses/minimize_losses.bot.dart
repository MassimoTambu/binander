part of minimize_losses_bot;

class MinimizeLossesBot implements Bot {
  @override
  late final MinimizeLossesConfig config;
  @override
  final String name;
  late final MinimizeLossesStrategy strategy;
  late final EventEmitter _eventEmitter;
  late final String _senderName;

  MinimizeLossesBot({
    required this.config,
    required this.name,
    required this.strategy,
  }) {
    _eventEmitter = EventEmitter();
    _senderName = 'Bot_' + name;
  }

  MinimizeLossesBot.create({
    required this.name,
    required int dailyLossSellOrders,
    required int maxInvestmentPerOrder,
    required double percentageSellOrder,
    required Duration timerBuyOrder,
  }) {
    _eventEmitter = EventEmitter();
    _senderName = 'Bot_' + name;
    config = MinimizeLossesConfig.create(
        dailyLossSellOrders: dailyLossSellOrders,
        maxInvestmentPerOrder: maxInvestmentPerOrder,
        percentageSellOrder: percentageSellOrder,
        timerBuyOrder: timerBuyOrder);
    strategy = MinimizeLossesStrategy.create();
  }

  @override
  void start() {
    _eventEmitter.emit(
        EmitterCategories.bot.name, _senderName, name + ' has started!');
  }

  @override
  void stop() {
    _eventEmitter.emit(
        EmitterCategories.bot.name, _senderName, name + ' has stopped!');
  }
}
