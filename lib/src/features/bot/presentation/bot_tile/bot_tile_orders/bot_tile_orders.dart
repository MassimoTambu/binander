import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:binander/src/features/bot/domain/order_kinds.dart';
import 'package:binander/src/features/bot/domain/pipeline.dart';
import 'package:binander/src/features/bot/presentation/bot_tile/bot_order_tile_provider.dart';
import 'package:binander/src/features/bot/presentation/bot_tile/bot_tile_notifier.dart';
import 'package:binander/src/features/bot/presentation/bot_tile/bot_tile_orders/bot_tile_run_orders.dart';

class BotTileOrders extends ConsumerWidget {
  const BotTileOrders({required this.pipeline, super.key});

  final Pipeline pipeline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final botTileController =
        ref.watch(currentBotTileNotifierProvider(pipeline));
    final allOrders =
        botTileController.pipeline.bot.data.ordersHistory.runOrders;
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
              value: botTileController.orderKind,
              hint: const Text('Sort by'),
              icon: const Icon(Icons.sort),
              onChanged: (OrderKinds? ordersOrder) {
                if (ordersOrder != null) {
                  ref
                      .read(currentBotTileNotifierProvider(pipeline).notifier)
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
