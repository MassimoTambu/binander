import 'dart:async';

import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/modules/bot/models/bot_phases.enum.dart';
import 'package:bottino_fortino/modules/bot/models/bot_status.dart';
import 'package:bottino_fortino/modules/bot/models/orders_history.dart';

abstract class PipelineData {
  final OrdersHistory ordersHistory;
  var status = const BotStatus(BotPhases.offline, 'offline');
  Timer? timer;
  AveragePrice? lastAveragePrice;
  final symbolPrecision = 8;
  var counter = 0;

  PipelineData({OrdersHistory? ordersHistory})
      : ordersHistory = ordersHistory == null
            ? ordersHistory = OrdersHistory([])
            : ordersHistory = ordersHistory;
}
