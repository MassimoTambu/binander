part of bot;

abstract class Bot {
  final String uuid;
  final BotTypes type;
  final String name;
  final bool testNet;
  final Config config;

  var status = BotStatus(BotPhases.offline, 'offline');

  Bot(
    this.uuid,
    this.type, {
    required this.name,
    required this.config,
    required this.testNet,
  });

  void start(WidgetRef ref);
  void stop(WidgetRef ref, {String reason = ''});
  void remove(WidgetRef ref);

  static String botNameName = "bot_name";
  static String testNetName = "test_net";

  factory Bot.fromJson(Map<String, dynamic> json) {
    if (json['type']! == BotTypes.minimizeLosses.name) {
      return MinimizeLossesBot.fromJson(json);
    }

    // DEFAULT
    return MinimizeLossesBot.fromJson(json);
  }

  Map<String, dynamic> toJson();
}
