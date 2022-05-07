part of dashboard_module;

class BotTile extends ConsumerWidget {
  const BotTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bot =
        ref.watch(botTileProvider.notifier.select((p) => p.pipeline.bot));
    return ExpansionTile(
      title: Wrap(
        spacing: 8,
        runSpacing: 5,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                bot.name,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(width: 20),
              GainsChip(bot.pipelineData.ordersHistory.allOrders),
            ],
          ),
          const BotTileChips(),
        ],
      ),
      childrenPadding: const EdgeInsets.all(18),
      children: const [
        BotTileButtons(),
        BotTileOrders(),
      ],
    );
  }
}
