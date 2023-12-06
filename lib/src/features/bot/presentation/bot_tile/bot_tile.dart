import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:binander/src/features/bot/domain/bot_tile_notifier.dart';
import 'package:binander/src/features/bot/domain/bots/minimize_losses/minimize_losses_config.dart';
import 'package:binander/src/features/bot/domain/bots/minimize_losses/minimize_losses_pipeline.dart';
import 'package:binander/src/features/bot/domain/bots/minimize_losses/minimize_losses_pipeline_data.dart';
import 'package:binander/src/features/bot/presentation/bot_tile/bot_tile_buttons.dart';
import 'package:binander/src/features/bot/presentation/bot_tile/bot_tile_controller.dart';
import 'package:binander/src/features/bot/presentation/bot_tile/bot_tile_orders/bot_tile_orders.dart';
import 'package:binander/src/features/bot/presentation/total_gains_chip.dart';
import 'package:binander/src/utils/floor_to_double_with_decimals.dart';
import 'package:binander/src/utils/string_capitalize.dart';

part 'bot_tile.g.dart';

@riverpod
BotTileNotifier currentBotTileNotifier(CurrentBotTileNotifierRef ref) =>
    throw UnimplementedError();

class BotTile extends ConsumerWidget {
  const BotTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final botTile = ref.watch(
        currentBotTileController(ref.watch(currentBotTileNotifierProvider)));

    final pipeline = botTile.pipeline;
    final bot = pipeline.bot;
    final botStatus = botTile.pipeline.bot.data.status;
    final testNet = botTile.pipeline.bot.testNet;

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
                builder: (context) {
                  return AlertDialog(
                    title: Text('Bot ${bot.name} info'),
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.height / 3,
                      child: Column(children: [
                        const SizedBox(height: 20),
                        Expanded(
                          child: Text(
                              '${MinimizeLossesConfig.dailyLossSellOrdersPublicName}: ${bot.config.dailyLossSellOrders}'),
                        ),
                        Expanded(
                          child: Text(
                              '${MinimizeLossesConfig.maxInvestmentPerOrderPublicName}: ${bot.config.maxInvestmentPerOrder}'),
                        ),
                        Expanded(
                          child: Text(
                              '${MinimizeLossesConfig.percentageSellOrderPublicName}: ${bot.config.percentageSellOrder}'),
                        ),
                        Expanded(
                          child: Text(
                              '${MinimizeLossesConfig.symbolPublicName}: ${bot.config.symbol}'),
                        ),
                        Expanded(
                          child: Text(
                              '${MinimizeLossesConfig.timerBuyOrderPublicName}: ${bot.config.timerBuyOrder?.inMinutes} minutes'),
                        ),
                        Expanded(
                          child: Text(
                              '${MinimizeLossesConfig.autoRestartPublicName}: ${bot.config.autoRestart}'),
                        ),
                      ]),
                    ),
                  );
                }),
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
              pipeline is MinimizeLossesPipeline) ...[
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
                'New Stop: ${pipeline.calculateNewOrderStopPriceWithProperties().floorToDoubleWithDecimals(bot.data.orderPrecision)}',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Chip(
              label: Text(
                'T: ${pipeline.calculatePercentageOfDifference().floorToDoubleWithDecimals(bot.data.orderPrecision)}/${MinimizeLossesPipelineData.tolerance}',
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
        const BotTileButtons(),
        const SizedBox(height: 16),
        const BotTileOrders(),
      ],
    );
  }
}
