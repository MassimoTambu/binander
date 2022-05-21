import 'package:bottino_fortino/modules/dashboard/providers/bot_tile.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BotTileButtons extends ConsumerWidget {
  const BotTileButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final botTile = ref.watch(botTileProvider.notifier);
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
      ],
    );
  }
}
