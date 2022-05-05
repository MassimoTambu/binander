part of bot;

abstract class PipelineData {
  final OrdersHistory ordersHistory;
  var status = const BotStatus(BotPhases.offline, 'offline');
  Timer? timer;
  var pipelineCounter = 0;

  PipelineData({OrdersHistory? ordersHistory})
      : ordersHistory = ordersHistory == null
            ? ordersHistory = OrdersHistory([], [])
            : ordersHistory = ordersHistory;
}
