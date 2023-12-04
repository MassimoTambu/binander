import 'package:binander/src/features/bot/domain/order_kinds.dart';
import 'package:binander/src/features/bot/presentation/bot_order_tile_provider.dart';
import 'package:binander/src/features/bot/presentation/bot_tile_controller.dart';
import 'package:binander/src/features/bot/presentation/bot_tile_orders/bot_tile_run_orders.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BotTileOrders extends ConsumerWidget {
  const BotTileOrders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOrders = ref
        .watch(currentBotTileControllerProvider)
        .pipeline
        .bot
        .data
        .ordersHistory
        .runOrders;
    const items = [
      {'Date (newer)': OrderKinds.dateNewest},
      {'Date (oldest)': OrderKinds.dateOldest},
      {'Gains': OrderKinds.gains},
      {'Losses': OrderKinds.losses},
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DropdownButton<OrderKinds>(
              items: items.map<DropdownMenuItem<OrderKinds>>(
                  (Map<String, OrderKinds> kv) {
                return DropdownMenuItem(
                  value: kv.values.first,
                  child: Text(kv.keys.first),
                );
              }).toList(),
              value: ref.watch(currentBotTileControllerProvider).selectedOrder,
              hint: const Text('Sort by'),
              icon: const Icon(Icons.sort),
              onChanged: (OrderKinds? ordersOrder) {
                if (ordersOrder != null) {
                  ref
                      .read(currentBotTileControllerProvider.notifier)
                      .orderBy(ordersOrder);
                }
              },
            ),
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          itemCount: allOrders.length,
          itemBuilder: (context, index) => ProviderScope(
            overrides: [
              currentRunOrdersTileProvider.overrideWithValue(allOrders[index]),
            ],
            child: const BotTileRunOrders(),
          ),
          separatorBuilder: (context, index) => const Divider(),
        ),
      ],
    );
  }
}
