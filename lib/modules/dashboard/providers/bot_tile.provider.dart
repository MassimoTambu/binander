import 'package:bottino_fortino/modules/bot/models/bot_phases.enum.dart';
import 'package:bottino_fortino/modules/bot/models/interfaces/pipeline.interface.dart';
import 'package:bottino_fortino/modules/bot/models/orders_pair.dart';
import 'package:bottino_fortino/modules/dashboard/models/orders_order.enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    var aTime = a.sellOrder
        ?.map(data: (o) => o.updateTime, newLimit: (o) => o.transactTime);

    aTime ??= a.buyOrder
        .map(data: (o) => o.updateTime, newLimit: (o) => o.transactTime);

    var bTime = b.sellOrder
        ?.map(data: (o) => o.updateTime, newLimit: (o) => o.transactTime);

    bTime ??= b.buyOrder
        .map(data: (o) => o.updateTime, newLimit: (o) => o.transactTime);

    if (newest) {
      return bTime!.compareTo(aTime!);
    }

    return aTime!.compareTo(bTime!);
  }
}
