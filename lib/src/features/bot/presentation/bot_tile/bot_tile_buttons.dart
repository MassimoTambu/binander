import 'package:binander/src/features/bot/domain/bot_tile_data.dart';
import 'package:binander/src/features/bot/presentation/bot_tile/bot_tile_notifier.dart';
import 'package:binander/src/features/bot/presentation/pipeline_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BotTileButtons extends ConsumerWidget {
  const BotTileButtons({required this.botTileData, super.key});

  final BotTileData botTileData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final botTile = ref.watch(currentBotTileNotifierProvider(botTileData));
    final isStartDisabled = botTile.isStartButtonDisabled;
    final isPauseDisabled = botTile.isPauseButtonDisabled;
    final isStarted = !botTile.hasToStart;

    return Row(
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              isStarted ? Colors.red : Theme.of(context).colorScheme.primary,
            ),
          ),
          onPressed: isStartDisabled
              ? null
              : () {
                  if (!isStarted) {
                    botTile.pipeline.start();
                  } else {
                    botTile.pipeline.shutdown();
                  }
                },
          child: Text(isStarted ? 'Stop' : 'Start',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              isStarted
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
            ),
          ),
          onPressed: isPauseDisabled
              ? null
              : () {
                  if (isStarted) {
                    botTile.pipeline.pause();
                  }
                },
          child: const Text('Pause',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const Expanded(child: SizedBox()),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          ),
          onPressed: () async {
            final confirm = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Builder(builder: (context) {
                      // Get available width of the build area of this widget
                      final width = MediaQuery.of(context).size.width;

                      return SizedBox(
                        width: width * 33 / 100,
                        child: Text(
                          'Do you really want to remove "${botTile.pipeline.bot.name}"? Any opened buy and sell orders will be cancelled.',
                          textAlign: TextAlign.justify,
                        ),
                      );
                    }),
                    actions: [
                      TextButton(
                          onPressed: () => context.pop(false),
                          child: const Text('No')),
                      TextButton(
                          onPressed: () => context.pop(true),
                          child: const Text('Yes')),
                    ],
                  );
                });

            if (confirm == true) {
              await ref
                  .read(pipelineControllerProvider.notifier)
                  .removeBots([botTile.pipeline.bot.uuid]);
            }
          },
          child: const Text('Remove',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
