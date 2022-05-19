import 'package:bottino_fortino/modules/dashboard/providers/bot_tile.provider.dart';
import 'package:bottino_fortino/modules/dashboard/widgets/bot_tile/bot_tile_buttons.dart';
import 'package:bottino_fortino/modules/dashboard/widgets/bot_tile_orders/bot_tile_orders.dart';
import 'package:bottino_fortino/modules/dashboard/widgets/total_gains_chip.dart';
import 'package:bottino_fortino/utils/extensions/double.extension.dart';
import 'package:bottino_fortino/utils/extensions/string.extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BotTile extends ConsumerWidget {
  const BotTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pipeline =
        ref.watch(botTileProvider.notifier.select((p) => p.pipeline));
    return ExpansionTile(
      title: Wrap(
        spacing: 8,
        runSpacing: 5,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                pipeline.bot.name,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(width: 20),
              TotalGainsChip(pipeline.ordersHistory.runOrders),
              const SizedBox(width: 8),
              Chip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.attach_money_rounded, color: Colors.green),
                    const SizedBox(width: 5),
                    Text(
                      pipeline.lastAveragePrice == null
                          ? 'No data'
                          : '${pipeline.lastAveragePrice!.price.floorToDoubleWithDecimals(2)}',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const _BotTileRightChips(),
        ],
      ),
      childrenPadding: const EdgeInsets.all(18),
      children: const [
        BotTileButtons(),
        BotTileOrders(),
      ],
    );
  }
}

class _BotTileRightChips extends ConsumerWidget {
  const _BotTileRightChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final botStatus =
        ref.watch(botTileProvider.notifier.select((p) => p.pipeline.status));
    final testNet = ref
        .watch(botTileProvider.notifier.select((p) => p.pipeline.bot.testNet));

    return Wrap(
      spacing: 8,
      runSpacing: 5,
      alignment: WrapAlignment.end,
      children: [
        Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.black,
            radius: 8,
            child: CircleAvatar(
              backgroundColor: botStatus.getBotPhaseColor(),
              radius: 5.4,
            ),
          ),
          label: Text(
            botStatus.phase.name.capitalizeFirst(),
            style: const TextStyle(
              height: 1.1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (testNet)
          Chip(
            backgroundColor: Theme.of(context).colorScheme.primary,
            label: Text(
              'TestNet',
              style: TextStyle(
                height: 1.1,
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
      ],
    );
  }
}
