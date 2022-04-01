part of bot;

abstract class PipelineData {
  final OrdersHistory ordersHistory;
  var status = const BotStatus(BotPhases.offline, 'offline');
  Timer? timer;

  PipelineData({this.ordersHistory = const OrdersHistory([])});
}
