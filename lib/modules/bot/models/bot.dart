part of bot;

@freezed
class Bot with _$Bot {
  const factory Bot.minimizeLosses(
    String uuid,
    MinimizeLossesPipeLineData pipelineData, {
    required String name,
    required bool testNet,
    required MinimizeLossesConfig config,
    @Default(BotTypes.minimizeLosses) BotTypes type,
  }) = MinimizeLossesBot;

  static String botNameName = "bot_name";
  static String testNetName = "test_net";

  factory Bot.fromJson(Map<String, dynamic> json) => _$BotFromJson(json);
}
