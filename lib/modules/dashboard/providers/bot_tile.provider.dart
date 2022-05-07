part of dashboard_module;

final botTileProvider =
    StateNotifierProvider<BotTileProvider, List<OrdersPair>>(
        (ref) => throw UnimplementedError());

class BotTileProvider extends StateNotifier<List<OrdersPair>> {
  final Pipeline pipeline;
  final bool hasToStart;
  final bool isStartButtonDisabled;
  final bool isPauseButtonDisabled;
  OrdersOrder selectedOrder;

  BotTileProvider(this.pipeline)
      : hasToStart =
            pipeline.bot.pipelineData.status.phase == BotPhases.offline ||
                pipeline.bot.pipelineData.status.phase == BotPhases.error,
        isStartButtonDisabled =
            pipeline.bot.pipelineData.status.phase == BotPhases.stopping,
        isPauseButtonDisabled =
            pipeline.bot.pipelineData.status.phase == BotPhases.stopping ||
                pipeline.bot.pipelineData.status.phase == BotPhases.offline,
        selectedOrder = OrdersOrder.dateNewest,
        super([...pipeline.bot.pipelineData.ordersHistory.allOrders]
          ..sort((a, b) => _sortByDate(a, b)));

  void orderBy(OrdersOrder orderFactor) {
    switch (orderFactor) {
      case OrdersOrder.dateNewest:
        state.sort((a, b) => _sortByDate(a, b));
        break;
      case OrdersOrder.dateOldest:
        state.sort((a, b) => _sortByDate(a, b, newest: false));
        break;
      case OrdersOrder.gains:
        state.sort((a, b) => (b.gains - a.gains).ceil());
        break;
      case OrdersOrder.losses:
        state.sort((a, b) => (a.gains - b.gains).ceil());
        break;
    }

    selectedOrder = orderFactor;
    state = [...state];
  }

  static int _sortByDate(OrdersPair a, OrdersPair b, {bool newest = true}) {
    var aTime = a.sellOrder?.map(
        orderData: (o) => o.updateTime,
        orderNew: (o) => o.transactTime,
        orderCancel: (o) => o.transactTime);

    aTime ??= a.buyOrder.map(
        orderData: (o) => o.updateTime,
        orderNew: (o) => o.transactTime,
        orderCancel: (o) => o.transactTime);

    var bTime = b.sellOrder?.map(
        orderData: (o) => o.updateTime,
        orderNew: (o) => o.transactTime,
        orderCancel: (o) => o.transactTime);

    bTime ??= b.buyOrder.map(
        orderData: (o) => o.updateTime,
        orderNew: (o) => o.transactTime,
        orderCancel: (o) => o.transactTime);

    if (newest) {
      return bTime!.compareTo(aTime!);
    }

    return aTime!.compareTo(bTime!);
  }
}
