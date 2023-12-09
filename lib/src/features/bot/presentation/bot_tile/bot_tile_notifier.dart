import 'package:binander/src/features/bot/domain/bot_tile_data.dart';
import 'package:binander/src/features/bot/domain/bots/bot_phases.dart';
import 'package:binander/src/features/bot/domain/order_kinds.dart';
import 'package:binander/src/features/bot/domain/pipeline.dart';
import 'package:binander/src/features/bot/domain/run_orders.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bot_tile_notifier.g.dart';

@riverpod
class CurrentBotTileNotifier extends _$CurrentBotTileNotifier {
  @override
  BotTileData build(Pipeline pipeline) =>
      BotTileData(pipeline: pipeline, selectedOrder: OrderKinds.dateOldest);

  bool get hasToStart =>
      state.pipeline.bot.data.status.phase == BotPhases.offline ||
      state.pipeline.bot.data.status.phase == BotPhases.error;
  bool get isStartButtonDisabled =>
      state.pipeline.bot.data.status.phase == BotPhases.stopping;
  bool get isPauseButtonDisabled =>
      state.pipeline.bot.data.status.phase == BotPhases.stopping ||
      state.pipeline.bot.data.status.phase == BotPhases.offline;

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
