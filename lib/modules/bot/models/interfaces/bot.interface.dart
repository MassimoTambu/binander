part of bot;

abstract class Bot implements Pipeline {
  final String uuid;
  final BotTypes type;
  final String name;
  final bool testNet;
  final Config config;
  final OrdersHistory ordersHistory;
  late final WidgetRef ref;

  Bot(
    this.uuid,
    this.type, {
    required this.name,
    required this.testNet,
    required this.config,
    required this.ordersHistory,
  });

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
