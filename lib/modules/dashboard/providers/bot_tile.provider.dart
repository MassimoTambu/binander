import 'package:bottino_fortino/modules/bot/models/bot_phases.enum.dart';
import 'package:bottino_fortino/modules/bot/models/interfaces/pipeline.interface.dart';
import 'package:bottino_fortino/modules/bot/models/run_orders.dart';
import 'package:bottino_fortino/modules/dashboard/models/bot_tile.notifier.dart';
import 'package:bottino_fortino/modules/dashboard/models/orders_order.enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final botTileProvider = StateNotifierProvider<BotTileProvider, BotTileNotifier>(
    (ref) => throw UnimplementedError());

class BotTileProvider extends StateNotifier<BotTileNotifier> {
  BotTileProvider(Pipeline pipeline)
      : super(BotTileNotifier(
          pipeline: pipeline,
          hasToStart: pipeline.bot.data.status.phase == BotPhases.offline ||
              pipeline.bot.data.status.phase == BotPhases.error,
          isStartButtonDisabled:
              pipeline.bot.data.status.phase == BotPhases.stopping,
          isPauseButtonDisabled:
              pipeline.bot.data.status.phase == BotPhases.stopping ||
                  pipeline.bot.data.status.phase == BotPhases.offline,
          selectedOrder: OrdersOrder.dateNewest,
        ));
// ..sort((a, b) => _sortByDate(a, b))

  void orderBy(OrdersOrder orderFactor) {
    final runOrders = state.pipeline.bot.data.ordersHistory.runOrders;
    switch (orderFactor) {
      case OrdersOrder.dateNewest:
        runOrders.sort((a, b) => _sortByDate(a, b));
        break;
      case OrdersOrder.dateOldest:
        runOrders.sort((a, b) => _sortByDate(a, b, newest: false));
        break;
      case OrdersOrder.gains:
        runOrders.sort((a, b) => (b.gains - a.gains).ceil());
        break;
      case OrdersOrder.losses:
        runOrders.sort((a, b) => (a.gains - b.gains).ceil());
        break;
    }

    state = state.copyWith(selectedOrder: orderFactor);
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
