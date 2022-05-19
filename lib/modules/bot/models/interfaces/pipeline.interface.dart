import 'dart:async';

import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/modules/bot/models/bot.dart';
import 'package:bottino_fortino/modules/bot/models/bot_phases.enum.dart';
import 'package:bottino_fortino/modules/bot/models/bot_status.dart';
import 'package:bottino_fortino/modules/bot/models/orders_history.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Pipeline {
  final Ref ref;
  final Bot bot;
  final OrdersHistory ordersHistory;
  var status = const BotStatus(BotPhases.offline, 'offline');
  Timer? timer;
  AveragePrice? lastAveragePrice;
  var pipelineCounter = 0;

  Pipeline(this.ref, this.bot, {OrdersHistory? ordersHistory})
      : ordersHistory = ordersHistory == null
            ? ordersHistory = OrdersHistory([])
            : ordersHistory = ordersHistory;

  void start();
  void pause();
  void shutdown({String reason = ''});
}
