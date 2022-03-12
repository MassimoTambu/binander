part of dashboard_module;

final currentBot = Provider<Bot>((ref) => throw UnimplementedError());

class BotTile extends ConsumerWidget {
  const BotTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bot = ref.watch(currentBot);
    return ExpansionTile(
      title: Wrap(
        spacing: 8,
        runSpacing: 5,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            bot.name,
            style: Theme.of(context).textTheme.headline5,
          ),
          BotTileChips(uuid: bot.uuid)
        ],
      ),
      childrenPadding: const EdgeInsets.all(10),
      children: [
        const BotTileDetails(),
        const BotTileButton(),
        // TODO add History Orders
        // ProviderScope(
        //   overrides: [
        //     isTestNet.overrideWithValue(bot.testNet),
        //   ],
        //   child: const History(),
        // ),
      ],
    );
  }
}
