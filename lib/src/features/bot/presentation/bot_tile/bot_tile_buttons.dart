import 'package:auto_route/auto_route.dart';
import 'package:binander/modules/dashboard/providers/bot_tile.provider.dart';
import 'package:binander/providers/pipeline.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BotTileButtons extends ConsumerWidget {
  const BotTileButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final botTile = ref.watch(botTileProvider);
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
                          onPressed: () => context.router.pop(false),
                          child: const Text('No')),
                      TextButton(
                          onPressed: () => context.router.pop(true),
                          child: const Text('Yes')),
                    ],
                  );
                });

            if (confirm == true) {
              await ref
                  .read(pipelineProvider.notifier)
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
