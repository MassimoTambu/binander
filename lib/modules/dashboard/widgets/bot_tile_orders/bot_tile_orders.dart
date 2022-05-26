import 'package:bottino_fortino/modules/dashboard/models/orders_order.enum.dart';
import 'package:bottino_fortino/modules/dashboard/providers/bot_order_tile.provider.dart';
import 'package:bottino_fortino/modules/dashboard/providers/bot_tile.provider.dart';
import 'package:bottino_fortino/modules/dashboard/widgets/bot_tile_orders/bot_tile_run_orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BotTileOrders extends ConsumerWidget {
  const BotTileOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOrders = ref.watch(botTileProvider
        .select((p) => p.pipeline.bot.data.ordersHistory.runOrders));
    const items = [
      {'Date (newer)': OrdersOrder.dateNewest},
      {'Date (oldest)': OrdersOrder.dateOldest},
      {'Gains': OrdersOrder.gains},
      {'Losses': OrdersOrder.losses},
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DropdownButton(
              items: items.map<DropdownMenuItem<OrdersOrder>>(
                  (Map<String, OrdersOrder> kv) {
                return DropdownMenuItem<OrdersOrder>(
                  value: kv.values.first,
                  child: Text(kv.keys.first),
                );
              }).toList(),
              value: ref.watch(botTileProvider).selectedOrder,
              hint: const Text('Sort by'),
              icon: const Icon(Icons.sort),
              onChanged: (OrdersOrder? ordersOrder) {
                if (ordersOrder != null) {
                  ref.read(botTileProvider.notifier).orderBy(ordersOrder);
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
              currentRunOrdersTile.overrideWithValue(allOrders[index]),
            ],
            child: const BotTileRunOrders(),
          ),
          separatorBuilder: (context, index) => const Divider(),
        ),
      ],
    );
  }
}
