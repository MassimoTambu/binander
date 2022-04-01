part of dashboard_module;

final botTileProvider =
    Provider<BotTileProvider>((ref) => throw UnimplementedError());

class BotTileProvider {
  final Pipeline pipeline;
  late final bool hasToStart;
  late final bool isButtonDisabled;

  BotTileProvider(this.pipeline) {
    final data = pipeline.bot.pipelineData;
    hasToStart = data.status.phase == BotPhases.offline ||
        data.status.phase == BotPhases.error;
    isButtonDisabled = data.status.phase == BotPhases.stopping;
  }
}
