import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.config.dart';
import 'package:bottino_fortino/modules/bot/models/bot_types.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bot.freezed.dart';
part 'bot.g.dart';

@freezed
class Bot with _$Bot {
  const factory Bot.minimizeLosses(
    String uuid, {
    required String name,
    required bool testNet,
    required MinimizeLossesConfig config,
    @Default(BotTypes.minimizeLosses) BotTypes type,
  }) = MinimizeLossesBot;

  static String botNameName = "bot_name";
  static String testNetName = "test_net";

  factory Bot.fromJson(Map<String, dynamic> json) => _$BotFromJson(json);
}
