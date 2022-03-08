part of bot;

abstract class Pipeline {
  var status = BotStatus(BotPhases.offline, 'offline');

  void start(WidgetRef ref);
  void stop(WidgetRef ref, {String reason = ''});
}
