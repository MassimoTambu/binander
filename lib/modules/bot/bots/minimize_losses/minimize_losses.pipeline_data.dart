import 'dart:async';

import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/modules/bot/models/bot_phases.enum.dart';
import 'package:bottino_fortino/modules/bot/models/bot_status.dart';
import 'package:bottino_fortino/modules/bot/models/interfaces/pipeline_data.interface.dart';
import 'package:bottino_fortino/modules/bot/models/orders_history.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'minimize_losses.pipeline_data.freezed.dart';
part 'minimize_losses.pipeline_data.g.dart';

@unfreezed
class MinimizeLossesPipeLineData
    with _$MinimizeLossesPipeLineData
    implements PipelineData {
  const factory MinimizeLossesPipeLineData({
    @Default(OrdersHistory([])) @override final OrdersHistory ordersHistory,
    @override @Default(0) int pipelineCounter,
    @override @JsonKey(ignore: true) Timer? timer,
    @JsonKey(ignore: true) AveragePrice? lastAveragePrice,
    DateTime? buyOrderStartedAt,
    @override
    @JsonKey(ignore: true)
    @Default(BotStatus(BotPhases.offline, 'offline'))
        BotStatus status,
  }) = _MinimizeLossesPipeLineData;

  factory MinimizeLossesPipeLineData.fromJson(Map<String, dynamic> json) =>
      _$MinimizeLossesPipeLineDataFromJson(json);
}
