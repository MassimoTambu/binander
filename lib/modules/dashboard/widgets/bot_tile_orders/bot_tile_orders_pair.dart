part of dashboard_module;

class BotTileOrdersPair extends ConsumerWidget {
  const BotTileOrdersPair({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersPair = ref.watch(currentOrdersPairTile);

    return Column(
      children: [
        if (ordersPair.sellOrder != null && ordersPair.gains != 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GainsChip([ordersPair]),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OrderContainer(ordersPair.buyOrder),
            if (ordersPair.sellOrder != null)
              OrderContainer(ordersPair.sellOrder!)
          ],
        ),
      ],
    );
  }
}
