part of dashboard_module;

class BotTileButton extends ConsumerStatefulWidget {
  const BotTileButton({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BotTileButtonState();
}

class _BotTileButtonState extends ConsumerState<BotTileButton> {
  late final Bot bot;
  var isDisabled = false;
  var isStarted = false;

  bool isButtonDisabled() {
    if (bot.status.phase == BotPhases.stopping) {
      return true;
    }

    return false;
  }

  bool hasToStart() {
    if (bot.status.phase == BotPhases.offline ||
        bot.status.phase == BotPhases.error) {
      return true;
    }

    return false;
  }

  void onPressed(WidgetRef ref) {
    if (hasToStart()) {
      bot.start(ref);
    } else {
      bot.stop(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    bot = ref.watch(currentBot);
    isDisabled = isButtonDisabled();
    isStarted = !hasToStart();

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
          onPressed: isDisabled ? null : () => onPressed(ref),
        ),
      ],
    );
  }
}
