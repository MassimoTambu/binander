part of dashboard_module;

class BotTileChips extends ConsumerWidget {
  final String uuid;

  const BotTileChips({
    Key? key,
    required this.uuid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final botStatus = ref.watch(botProvider
        .select((p) => p.firstWhere((b) => b.uuid == uuid).pipeline.status));
    final testNet = ref.watch(
        botProvider.select((p) => p.firstWhere((b) => b.uuid == uuid).testNet));
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
              backgroundColor: botStatus.getBotPhaseColor(),
              radius: 5.4,
            ),
          ),
          label: Text(
            botStatus.phase.name.capitalizeFirst(),
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
