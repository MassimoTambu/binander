import 'package:binander/src/features/bot/domain/order_kinds.dart';
import 'package:binander/src/features/bot/domain/pipeline.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bot_tile_notifier.freezed.dart';

@freezed
class BotTileNotifier with _$BotTileNotifier {
  const factory BotTileNotifier({
    required Pipeline pipeline,
    required bool hasToStart,
    required bool isStartButtonDisabled,
    required bool isPauseButtonDisabled,
    @Default(OrderKinds.dateOldest) OrderKinds selectedOrder,
  }) = _BotTileNotifier;
}
