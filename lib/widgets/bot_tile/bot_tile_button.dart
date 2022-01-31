part of widgets;

class BotTileButton extends ConsumerStatefulWidget {
  final String uuid;

  const BotTileButton({Key? key, required this.uuid}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BotTileButtonState();
}

class _BotTileButtonState extends ConsumerState<BotTileButton> {
  var isDisabled = false;
  var isStarted = false;

  bool isButtonDisabled(BotPhases phase) {
    if (phase == BotPhases.stopping) {
      return true;
    }

    return false;
  }

  bool hasToStart(BotPhases phase) {
    if (phase == BotPhases.offline || phase == BotPhases.error) {
      return true;
    }

    return false;
  }

  void onPressed(WidgetRef ref, Bot bot) {
    if (hasToStart(bot.status.phase)) {
      bot.start(ref);
    } else {
      bot.stop(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bot = ref.watch(botProvider).firstWhere((b) => b.uuid == widget.uuid);
    final phase = bot.status.phase;

    isDisabled = isButtonDisabled(phase);
    isStarted = !hasToStart(phase);

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
          onPressed: isDisabled ? null : () => onPressed(ref, bot),
        ),
      ],
    );
  }
}
