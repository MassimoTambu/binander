part of bot;

class MinimizeLossesBot implements Bot {
  @override
  final MinimizeLossesConfig config;
  @override
  final String name;
  final MinimizeLossesStrategy strategy;
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
