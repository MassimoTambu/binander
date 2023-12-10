import 'package:binander/src/features/bot/domain/order_kinds.dart';
import 'package:binander/src/features/bot/domain/pipeline.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bot_tile_data.freezed.dart';

@freezed
class BotTileData with _$BotTileData {
  const factory BotTileData({
    required Pipeline pipeline,
    @Default(OrderKinds.dateOldest) OrderKinds orderKind,
  }) = _BotTileData;
}
