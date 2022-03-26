part of bot;

abstract class Pipeline {
  var status = const BotStatus(BotPhases.offline, 'offline');

  void start(WidgetRef ref);
  void stop(WidgetRef ref, {String reason = ''});
}
