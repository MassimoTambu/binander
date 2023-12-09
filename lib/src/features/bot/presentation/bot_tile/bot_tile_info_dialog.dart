import 'package:binander/src/features/bot/domain/bot_tile_data.dart';
import 'package:binander/src/features/bot/domain/bots/bot.dart';
import 'package:binander/src/features/bot/domain/bots/minimize_losses/minimize_losses_config.dart';
import 'package:binander/src/features/bot/presentation/bot_tile/bot_tile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BotTileInfoDialog extends ConsumerWidget {
  const BotTileInfoDialog({required this.botTileData, super.key});

  final BotTileData botTileData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bot = ref.watch(currentBotTileNotifierProvider(botTileData)
        .select((v) => v.pipeline.bot));
    return switch (bot) {
      AbsMinimizeLossesBot() => AlertDialog(
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
        ),
    };
  }
}
