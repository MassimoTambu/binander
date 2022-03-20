part of dashboard_module;

final botTileProvider =
    Provider<BotTileProvider>((ref) => throw UnimplementedError());

class BotTileProvider {
  final Bot bot;
  late final bool hasToStart;
  late final bool isButtonDisabled;

  BotTileProvider(this.bot) {
    hasToStart = bot.status.phase == BotPhases.offline ||
        bot.status.phase == BotPhases.error;
    isButtonDisabled = bot.status.phase == BotPhases.stopping;
  }
}
