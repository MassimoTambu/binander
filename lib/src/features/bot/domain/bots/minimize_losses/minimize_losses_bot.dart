import 'package:binander/src/features/bot/domain/bots/bot.dart';
import 'package:binander/src/features/bot/domain/bots/bot_types.dart';
import 'package:binander/src/features/bot/domain/bots/minimize_losses/minimize_losses_config.dart';
import 'package:binander/src/features/bot/domain/bots/minimize_losses/minimize_losses_pipeline_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'minimize_losses_bot.freezed.dart';
part 'minimize_losses_bot.g.dart';

@freezed
class MinimizeLossesBot
    with _$MinimizeLossesBot
    implements AbsMinimizeLossesBot {
  const factory MinimizeLossesBot(
    String uuid,
    MinimizeLossesPipelineData data, {
    required String name,
    required bool testNet,
    required MinimizeLossesConfig config,
    @Default(BotTypes.minimizeLosses) BotTypes type,
  }) = _MinimizeLossesBot;

  factory MinimizeLossesBot.fromJson(Map<String, dynamic> json) =>
      _$MinimizeLossesBotFromJson(json);
}
