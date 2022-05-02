part of bot;

abstract class Pipeline {
  final Ref ref;
  final Bot bot;

  const Pipeline(this.ref, this.bot);

  void start();
  void pause();
  void shutdown({String reason = ''});
}
