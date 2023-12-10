import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:binander/src/features/bot/domain/bots/minimize_losses/minimize_losses_pipeline.dart';
import 'package:binander/src/features/bot/domain/bots/minimize_losses/minimize_losses_pipeline_data.dart';
import 'package:binander/src/features/bot/domain/pipeline.dart';
import 'package:binander/src/features/bot/presentation/bot_tile/bot_tile_buttons.dart';
import 'package:binander/src/features/bot/presentation/bot_tile/bot_tile_info_dialog.dart';
import 'package:binander/src/features/bot/presentation/bot_tile/bot_tile_notifier.dart';
import 'package:binander/src/features/bot/presentation/bot_tile/bot_tile_orders/bot_tile_orders.dart';
import 'package:binander/src/features/bot/presentation/bot_tile/total_gains_chip.dart';
import 'package:binander/src/utils/floor_to_double_with_decimals.dart';
import 'package:binander/src/utils/string_capitalize.dart';

class BotTile extends ConsumerWidget {
  const BotTile({required this.pipeline, super.key});

  final Pipeline pipeline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final botTileData = ref.watch(currentBotTileNotifierProvider(pipeline));

    final bPipeline = botTileData.pipeline;
    final bot = botTileData.pipeline.bot;
    final botStatus = botTileData.pipeline.bot.data.status;
    final testNet = botTileData.pipeline.bot.testNet;

    return ExpansionTile(
      title: Wrap(
        spacing: 8,
        runSpacing: 5,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            bot.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IconButton(
            icon: Icon(Icons.info,
                color: Theme.of(context).colorScheme.onSecondary),
            splashRadius: 20,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => BotTileInfoDialog(pipeline: bPipeline),
            ),
          ),
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
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Chip(
            backgroundColor: Theme.of(context).colorScheme.primary,
            label: Text(
              testNet ? 'TestNet' : 'PubNet',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
          TotalGainsChip(bot.data.ordersHistory.runOrders),
          Chip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.attach_money_rounded, color: Colors.green),
                const SizedBox(width: 5),
                Text(
                  bot.data.lastAveragePrice == null
                      ? 'No data'
                      : '${bot.data.lastAveragePrice!.price.floorToDoubleWithDecimals(bot.data.orderPrecision)}',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          if (bot.data.ordersHistory.lastNotEndedRunOrders?.sellOrder != null &&
              bPipeline is MinimizeLossesPipeline) ...[
            Chip(
              label: Text(
                'Stop: ${bot.data.ordersHistory.lastNotEndedRunOrders?.sellOrder?.stopPrice?.floorToDoubleWithDecimals(bot.data.orderPrecision)}',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Chip(
              label: Text(
                'New Stop: ${bPipeline.calculateNewOrderStopPriceWithProperties().floorToDoubleWithDecimals(bot.data.orderPrecision)}',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Chip(
              label: Text(
                'T: ${bPipeline.calculatePercentageOfDifference().floorToDoubleWithDecimals(bot.data.orderPrecision)}/${MinimizeLossesPipelineData.tolerance}',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ]
        ],
      ),
      childrenPadding: const EdgeInsets.all(18),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'Status: ${bot.data.status.reason}',
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15),
          ),
        ),
        BotTileButtons(pipeline: bPipeline),
        const SizedBox(height: 16),
        BotTileOrders(pipeline: bPipeline),
      ],
    );
  }
}
