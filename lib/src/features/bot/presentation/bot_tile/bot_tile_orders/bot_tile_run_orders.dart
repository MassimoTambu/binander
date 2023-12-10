import 'package:binander/src/features/bot/presentation/bot_order_tile_provider.dart';
import 'package:binander/src/features/bot/presentation/bot_tile/bot_tile_orders/bot_tile_run_orders_execution_date.dart';
import 'package:binander/src/features/bot/presentation/bot_tile/bot_tile_orders/order_container.dart';
import 'package:binander/src/features/bot/presentation/total_gains_chip.dart';
import 'package:binander/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BotTileRunOrders extends ConsumerWidget {
  const BotTileRunOrders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runOrders = ref.watch(currentRunOrdersTileProvider);

    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: BotTileRunOrdersExecutionDate(runOrders: runOrders)),
        if (runOrders.sellOrder != null && runOrders.gains != 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TotalGainsChip([runOrders]),
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OrderContainer(runOrders.buyOrder!),
            if (runOrders.sellOrder != null)
              OrderContainer(runOrders.sellOrder!)
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () => context.pushNamed(AppRoute.runOrderHistory.name,
                extra: runOrders),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Show complete history'),
            ),
          ),
        ),
      ],
    );
  }
}
