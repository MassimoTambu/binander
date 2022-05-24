import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.config.dart';
import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.pipeline.dart';
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
    final botTile = ref.watch(botTileProvider.notifier);
    final pipeline = botTile.pipeline;
    final bot = botTile.pipeline.bot;
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
                bot.name,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(width: 4),
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
              const SizedBox(width: 20),
              TotalGainsChip(bot.data.ordersHistory.runOrders),
              const SizedBox(width: 8),
              Chip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.attach_money_rounded, color: Colors.green),
                    const SizedBox(width: 5),
                    Text(
                      bot.data.lastAveragePrice == null
                          ? 'No data'
                          : '${bot.data.lastAveragePrice!.price.floorToDoubleWithDecimals(2)}',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              if (bot.data.ordersHistory.lastNotEndedRunOrders?.sellOrder !=
                  null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Chip(
                    label: Text(
                      'Stop: ${bot.data.ordersHistory.lastNotEndedRunOrders?.sellOrder?.stopPrice?.floorToDoubleWithDecimals(2)}',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              if (bot.data.ordersHistory.lastNotEndedRunOrders?.sellOrder !=
                      null &&
                  pipeline is MinimizeLossesPipeline)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Chip(
                    label: Text(
                      'New Stop: ${pipeline.calculateNewOrderStopPriceWithProperties().floorToDoubleWithDecimals(2)}',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              if (bot.data.ordersHistory.lastNotEndedRunOrders?.sellOrder !=
                      null &&
                  pipeline is MinimizeLossesPipeline)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Chip(
                    label: Text(
                      'Σ: ${pipeline.calculatePercentageOfDifference().floorToDoubleWithDecimals(2)}',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),
          const _BotTileRightChips(),
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
        const BotTileOrders(),
      ],
    );
  }
}

class _BotTileRightChips extends ConsumerWidget {
  const _BotTileRightChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final botStatus = ref.watch(
        botTileProvider.notifier.select((p) => p.pipeline.bot.data.status));
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
