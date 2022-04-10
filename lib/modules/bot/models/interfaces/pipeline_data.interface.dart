part of bot;

abstract class PipelineData {
  late final OrdersHistory ordersHistory;
  var status = const BotStatus(BotPhases.offline, 'offline');
  Timer? timer;

  PipelineData({OrdersHistory? ordersHistory});
}
