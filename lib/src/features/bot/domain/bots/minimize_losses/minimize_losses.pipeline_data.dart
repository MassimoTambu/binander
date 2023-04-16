import 'dart:async';

import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/bot/models/bot_phases.dart';
import 'package:binander/src/features/bot/models/bot_status.dart';
import 'package:binander/src/features/bot/models/interfaces/pipeline_data.dart';
import 'package:binander/src/features/bot/models/orders_history.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'minimize_losses.pipeline_data.freezed.dart';
part 'minimize_losses.pipeline_data.g.dart';

@unfreezed
class MinimizeLossesPipelineData
    with _$MinimizeLossesPipelineData
    implements PipelineData {
  static const tolerance = 0.4;

  factory MinimizeLossesPipelineData({
    @override required final OrdersHistory ordersHistory,
    @override required final int orderPrecision,
    @override required final int quantityPrecision,
    @override @Default(0) int counter,
    @override @JsonKey(ignore: true) Timer? timer,
    @override @JsonKey(ignore: true) AveragePrice? lastAveragePrice,
    DateTime? buyOrderStartedAt,
    @override
    @JsonKey(ignore: true)
    @Default(BotStatus(BotPhases.offline, 'offline'))
        BotStatus status,
  }) = _MinimizeLossesPipeLineData;

  factory MinimizeLossesPipelineData.fromJson(Map<String, dynamic> json) =>
      _$MinimizeLossesPipelineDataFromJson(json);
}
