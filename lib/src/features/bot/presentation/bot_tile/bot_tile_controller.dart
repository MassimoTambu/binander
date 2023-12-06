import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:binander/src/features/bot/domain/bot_tile_notifier.dart';
import 'package:binander/src/features/bot/domain/order_kinds.dart';
import 'package:binander/src/features/bot/domain/run_orders.dart';

class BotTileController extends StateNotifier<BotTileNotifier> {
  BotTileController(super._state);

  void orderBy(OrderKinds orderFactor) {
    final runOrders = state.pipeline.bot.data.ordersHistory.runOrders;
    switch (orderFactor) {
      case OrderKinds.dateNewest:
        runOrders.sort((a, b) => _sortByDate(a, b));
      case OrderKinds.dateOldest:
        runOrders.sort((a, b) => _sortByDate(a, b, newest: false));
      case OrderKinds.gains:
        runOrders.sort((a, b) => (b.gains - a.gains).ceil());
      case OrderKinds.losses:
        runOrders.sort((a, b) => (a.gains - b.gains).ceil());
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

final currentBotTileController = StateNotifierProvider.autoDispose
    .family<BotTileController, BotTileNotifier, BotTileNotifier>(
        (ref, botTile) {
  return BotTileController(botTile);
});
