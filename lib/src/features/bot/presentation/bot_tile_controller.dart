import 'package:binander/src/features/bot/domain/bot_tile_notifier.dart';
import 'package:binander/src/features/bot/domain/bots/bot_phases.dart';
import 'package:binander/src/features/bot/domain/order_kinds.dart';
import 'package:binander/src/features/bot/domain/pipeline.dart';
import 'package:binander/src/features/bot/domain/run_orders.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bot_tile_controller.g.dart';

@riverpod
Pipeline currentPipeline() => throw UnimplementedError();

@riverpod
class BotTileController extends _$BotTileController {
  @override
  BotTileNotifier build() {
    final pipeline = ref.watch(currentPipelineProvider);
    return BotTileNotifier(
      pipeline: pipeline,
      hasToStart: pipeline.bot.data.status.phase == BotPhases.offline ||
          pipeline.bot.data.status.phase == BotPhases.error,
      isStartButtonDisabled:
          pipeline.bot.data.status.phase == BotPhases.stopping,
      isPauseButtonDisabled:
          pipeline.bot.data.status.phase == BotPhases.stopping ||
              pipeline.bot.data.status.phase == BotPhases.offline,
      selectedOrder: OrderKinds.dateNewest,
    );
  }

  void orderBy(OrderKinds orderFactor) {
    final runOrders = state.pipeline.bot.data.ordersHistory.runOrders;
    switch (orderFactor) {
      case OrderKinds.dateNewest:
        runOrders.sort((a, b) => _sortByDate(a, b));
        break;
      case OrderKinds.dateOldest:
        runOrders.sort((a, b) => _sortByDate(a, b, newest: false));
        break;
      case OrderKinds.gains:
        runOrders.sort((a, b) => (b.gains - a.gains).ceil());
        break;
      case OrderKinds.losses:
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
