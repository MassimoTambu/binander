part of bot;

abstract class Pipeline {
  final Bot bot;
  var status = BotStatus(BotPhases.offline, 'offline');

  Pipeline(this.bot);

  void start(WidgetRef ref);
  void stop(WidgetRef ref, {String reason = ''});
}
