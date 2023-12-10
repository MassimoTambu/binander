import 'package:binander/src/features/bot/domain/pipeline.dart';
import 'package:binander/src/features/bot/presentation/bot_tile/bot_tile_notifier.dart';
import 'package:binander/src/features/bot/presentation/pipeline_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BotTileButtons extends ConsumerWidget {
  const BotTileButtons({required this.pipeline, super.key});

  final Pipeline pipeline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final botTile = ref.watch(currentBotTileNotifierProvider(pipeline));
    final notifier =
        ref.watch(currentBotTileNotifierProvider(pipeline).notifier);
    final isStartDisabled = notifier.isStartButtonDisabled;
    final isPauseDisabled = notifier.isPauseButtonDisabled;
    final isStarted = !notifier.hasToStart;

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
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isStarted ? null : Colors.black)),
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
          child: Text('Pause',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isPauseDisabled ? Colors.grey : Colors.black)),
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
          child: Text('Remove',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
