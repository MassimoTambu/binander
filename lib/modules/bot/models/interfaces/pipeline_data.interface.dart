import 'dart:async';

import 'package:binander/api/api.dart';
import 'package:binander/modules/bot/models/bot_phases.enum.dart';
import 'package:binander/modules/bot/models/bot_status.dart';
import 'package:binander/modules/bot/models/orders_history.dart';

abstract class PipelineData {
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
