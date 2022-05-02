part of dashboard_module;

class BotTileButton extends ConsumerWidget {
  const BotTileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _botTileProvider = ref.watch(botTileProvider);
    final isDisabled = _botTileProvider.isButtonDisabled;
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
          onPressed: isDisabled
              ? null
              : () {
                  if (!isStarted) {
                    _botTileProvider.pipeline.start();
                  } else {
                    _botTileProvider.pipeline.shutdown();
                  }
                },
        ),
      ],
    );
  }
}
