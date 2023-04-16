import 'package:binander/src/features/bot/models/bot_phases.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bot_status.freezed.dart';

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
