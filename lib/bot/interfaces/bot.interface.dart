part of bot;

abstract class Bot {
  final String name;
  final Config config;

  Bot({required this.name, required this.config});

  void start();
  void stop();
}
