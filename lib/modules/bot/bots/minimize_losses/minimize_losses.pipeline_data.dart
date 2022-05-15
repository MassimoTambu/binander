import 'dart:async';

import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/modules/bot/models/bot_phases.enum.dart';
import 'package:bottino_fortino/modules/bot/models/bot_status.dart';
import 'package:bottino_fortino/modules/bot/models/interfaces/pipeline_data.interface.dart';
import 'package:bottino_fortino/modules/bot/models/orders_history.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'minimize_losses.pipeline_data.g.dart';

@JsonSerializable()
class MinimizeLossesPipeLineData implements PipelineData {
  @override
  final OrdersHistory ordersHistory;
  @override
  @JsonKey()
  int pipelineCounter = 0;
  @override
  @JsonKey(ignore: true)
  var status = const BotStatus(BotPhases.offline, 'offline');
  @override
  @JsonKey(ignore: true)
  Timer? timer;

  @JsonKey(ignore: true)
  AveragePrice? lastAveragePrice;
  DateTime? buyOrderStartedAt;
  Order? lastBuyOrder;
  OrderData? lastSellOrder;

  MinimizeLossesPipeLineData({OrdersHistory? ordersHistory})
      : ordersHistory = ordersHistory == null
            ? ordersHistory = OrdersHistory([], [])
            : ordersHistory = ordersHistory;

  factory MinimizeLossesPipeLineData.fromJson(Map<String, dynamic> json) =>
      _$MinimizeLossesPipeLineDataFromJson(json);

  Map<String, dynamic> toJson() => _$MinimizeLossesPipeLineDataToJson(this);
}
