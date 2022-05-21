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
class MinimizeLossesPipelineData
    with _$MinimizeLossesPipelineData
    implements PipelineData {
  static const tolerance = 0.4;

  factory MinimizeLossesPipelineData({
    @override required final OrdersHistory ordersHistory,
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
