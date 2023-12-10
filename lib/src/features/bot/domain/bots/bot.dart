import 'package:binander/src/features/bot/domain/bots/bot_types.dart';
import 'package:binander/src/features/bot/domain/bots/minimize_losses/minimize_losses_config.dart';
import 'package:binander/src/features/bot/domain/pipeline_data.dart';
import 'package:binander/src/features/settings/domain/config.dart';

sealed class Bot {
  static String botNameName = "bot_name";
  static String testNetName = "test_net";

  const Bot(
      this.uuid, this.data, this.name, this.testNet, this.config, this.type);

  final String uuid;
  final PipelineData data;
  final String name;
  final bool testNet;
  final Config config;
  final BotTypes type;

  Map<String, dynamic> toJson();
}

abstract interface class AbsMinimizeLossesBot implements Bot {
  const AbsMinimizeLossesBot(
      this.uuid, this.data, this.name, this.testNet, this.config, this.type);

  @override
  final String uuid;
  @override
  final AbsMinimizeLossesPipelineData data;
  @override
  final String name;
  @override
  final bool testNet;
  @override
  final MinimizeLossesConfig config;
  @override
  final BotTypes type;
}
