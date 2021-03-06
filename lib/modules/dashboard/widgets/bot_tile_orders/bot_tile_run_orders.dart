import 'package:auto_route/auto_route.dart';
import 'package:binander/modules/dashboard/providers/bot_order_tile.provider.dart';
import 'package:binander/modules/dashboard/widgets/bot_tile_orders/order_container.dart';
import 'package:binander/modules/dashboard/widgets/total_gains_chip.dart';
import 'package:binander/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BotTileRunOrders extends ConsumerWidget {
  const BotTileRunOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runOrders = ref.watch(currentRunOrdersTile);

    return Column(
      children: [
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
            onTap: () =>
                context.router.push(RunOrderHistoryRoute(runOrders: runOrders)),
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
