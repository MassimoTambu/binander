part of dashboard_module;

class BotTileButtons extends ConsumerWidget {
  const BotTileButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _botTileProvider = ref.watch(botTileProvider.notifier);
    final isStartDisabled = _botTileProvider.isStartButtonDisabled;
    final isPauseDisabled = _botTileProvider.isPauseButtonDisabled;
    final isStarted = !_botTileProvider.hasToStart;

    return Row(
      children: [
        ElevatedButton(
          child: Text(isStarted ? 'Stop' : 'Start',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              isStarted ? Colors.red : Theme.of(context).colorScheme.primary,
            ),
          ),
          onPressed: isStartDisabled
              ? null
              : () {
                  if (!isStarted) {
                    _botTileProvider.pipeline.start();
                  } else {
                    _botTileProvider.pipeline.shutdown();
                  }
                },
        ),
        ElevatedButton(
          child: const Text('Pause',
              style: TextStyle(fontWeight: FontWeight.bold)),
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
                    _botTileProvider.pipeline.pause();
                  }
                },
        ),
      ],
    );
  }
}
