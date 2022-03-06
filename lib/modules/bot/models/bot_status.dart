part of bot;

class BotStatus {
  BotPhases phase;
  String reason;

  BotStatus(this.phase, this.reason);

  Color getBotPhaseColor() {
    switch (phase) {
      case BotPhases.offline:
        return Colors.grey;
      case BotPhases.starting:
      case BotPhases.stopping:
        return Colors.orange;
      case BotPhases.error:
        return Colors.red;
      case BotPhases.online:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
