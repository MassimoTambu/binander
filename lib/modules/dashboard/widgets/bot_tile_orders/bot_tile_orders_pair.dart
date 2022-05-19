import 'package:bottino_fortino/modules/dashboard/providers/bot_order_tile.provider.dart';
import 'package:bottino_fortino/modules/dashboard/widgets/bot_tile_orders/order_container.dart';
import 'package:bottino_fortino/modules/dashboard/widgets/total_gains_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BotTileOrdersPair extends ConsumerWidget {
  const BotTileOrdersPair({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersPair = ref.watch(currentOrdersPairTile);

    return Column(
      children: [
        if (ordersPair.sellOrder != null && ordersPair.gains != 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TotalGainsChip([ordersPair]),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OrderContainer(ordersPair.buyOrder!),
            if (ordersPair.sellOrder != null)
              OrderContainer(ordersPair.sellOrder!)
          ],
        ),
      ],
    );
  }
}
