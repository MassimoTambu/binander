import 'dart:async';

import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/bot/domain/bots/bot_phases.dart';
import 'package:binander/src/features/bot/domain/bots/bot_status.dart';
import 'package:binander/src/features/bot/domain/orders_history.dart';

sealed class PipelineData {
  final OrdersHistory ordersHistory;
  var status = const BotStatus(BotPhases.offline, 'offline');
  Timer? timer;
  AveragePrice? lastAveragePrice;
  final orderPrecision = 8;
  final quantityPrecision = 8;
  var counter = 0;

  PipelineData({OrdersHistory? ordersHistory})
      : ordersHistory = ordersHistory == null
            ? ordersHistory = OrdersHistory([])
            : ordersHistory = ordersHistory;
}

abstract interface class AbsMinimizeLossesPipelineData
    implements PipelineData {}
