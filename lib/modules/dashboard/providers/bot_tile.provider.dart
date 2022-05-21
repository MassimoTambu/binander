import 'package:bottino_fortino/modules/bot/models/bot_phases.enum.dart';
import 'package:bottino_fortino/modules/bot/models/interfaces/pipeline.interface.dart';
import 'package:bottino_fortino/modules/bot/models/run_orders.dart';
import 'package:bottino_fortino/modules/dashboard/models/orders_order.enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final botTileProvider = StateNotifierProvider<BotTileProvider, List<RunOrders>>(
    (ref) => throw UnimplementedError());

class BotTileProvider extends StateNotifier<List<RunOrders>> {
  final Pipeline pipeline;
  final bool hasToStart;
  final bool isStartButtonDisabled;
  final bool isPauseButtonDisabled;
  OrdersOrder selectedOrder;

  BotTileProvider(this.pipeline)
      : hasToStart = pipeline.bot.data.status.phase == BotPhases.offline ||
            pipeline.bot.data.status.phase == BotPhases.error,
        isStartButtonDisabled =
            pipeline.bot.data.status.phase == BotPhases.stopping,
        isPauseButtonDisabled =
            pipeline.bot.data.status.phase == BotPhases.stopping ||
                pipeline.bot.data.status.phase == BotPhases.offline,
        selectedOrder = OrdersOrder.dateNewest,
        super([...pipeline.bot.data.ordersHistory.runOrders]
          ..sort((a, b) => _sortByDate(a, b)));

  List<RunOrders> get allOrders => state;

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

  static int _sortByDate(RunOrders a, RunOrders b, {bool newest = true}) {
    final aTime =
        a.sellOrder != null ? a.sellOrder!.updateTime : a.buyOrder!.updateTime;

    final bTime =
        b.sellOrder != null ? b.sellOrder!.updateTime : b.buyOrder!.updateTime;

    if (newest) {
      return bTime.compareTo(aTime);
    }

    return aTime.compareTo(bTime);
  }
}
