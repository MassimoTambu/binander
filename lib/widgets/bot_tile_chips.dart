part of widgets;

class BotTileChips extends StatelessWidget {
  final bool testNet;
  final BotStatus botStatus;

  const BotTileChips({
    Key? key,
    required this.testNet,
    required this.botStatus,
  }) : super(key: key);

  Color getBotPhaseColor() {
    switch (botStatus.botPhase) {
      case BotPhases.offline:
        return Colors.grey;
      case BotPhases.loading:
        return Colors.orange;
      case BotPhases.error:
        return Colors.red;
      case BotPhases.online:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: getBotPhaseColor(),
              radius: 5.4,
            ),
          ),
          label: Text(
            capitalize(botStatus.botPhase.name),
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
