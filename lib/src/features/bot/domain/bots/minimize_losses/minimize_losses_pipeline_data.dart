import 'dart:async';

import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/bot/domain/bots/bot_phases.dart';
import 'package:binander/src/features/bot/domain/bots/bot_status.dart';
import 'package:binander/src/features/bot/domain/orders_history.dart';
import 'package:binander/src/features/bot/domain/pipeline_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'minimize_losses_pipeline_data.freezed.dart';
part 'minimize_losses_pipeline_data.g.dart';

@unfreezed
class MinimizeLossesPipelineData
    with _$MinimizeLossesPipelineData
    implements AbsMinimizeLossesPipelineData {
  static const tolerance = 0.4;

  factory MinimizeLossesPipelineData({
    @override required final OrdersHistory ordersHistory,
    @override required final int orderPrecision,
    @override required final int quantityPrecision,
    @override @Default(0) int counter,
    @override
    @JsonKey(includeFromJson: false, includeToJson: false)
    Timer? timer,
    @override
    @JsonKey(includeFromJson: false, includeToJson: false)
    AveragePrice? lastAveragePrice,
    DateTime? buyOrderStartedAt,
    @override
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(BotStatus(BotPhases.offline, 'offline'))
    BotStatus status,
  }) = _MinimizeLossesPipeLineData;

  factory MinimizeLossesPipelineData.fromJson(Map<String, dynamic> json) =>
      _$MinimizeLossesPipelineDataFromJson(json);
}
