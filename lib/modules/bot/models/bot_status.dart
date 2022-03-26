part of bot;

@freezed
class BotStatus with _$BotStatus {
  const BotStatus._();
  const factory BotStatus(BotPhases phase, String reason) = _BotStatus;

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
