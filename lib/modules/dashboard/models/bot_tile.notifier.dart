import 'package:bottino_fortino/modules/bot/models/interfaces/pipeline.interface.dart';
import 'package:bottino_fortino/modules/dashboard/models/orders_order.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bot_tile.notifier.freezed.dart';

@freezed
class BotTileNotifier with _$BotTileNotifier {
  const factory BotTileNotifier({
    required Pipeline pipeline,
    required bool hasToStart,
    required bool isStartButtonDisabled,
    required bool isPauseButtonDisabled,
    required OrdersOrder selectedOrder,
  }) = _BotTileNotifier;
}
