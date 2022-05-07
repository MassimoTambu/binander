part of dashboard_module;

class BotTileOrders extends ConsumerWidget {
  const BotTileOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOrders = ref.watch(botTileProvider);
    const items = [
      {'Date (newer)': OrdersOrder.dateNewest},
      {'Date (oldest)': OrdersOrder.dateOldest},
      {'Gains': OrdersOrder.gains},
      {'Losses': OrdersOrder.losses},
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DropdownButton(
              items: items.map<DropdownMenuItem<OrdersOrder>>(
                  (Map<String, OrdersOrder> kv) {
                return DropdownMenuItem<OrdersOrder>(
                  value: kv.values.first,
                  child: Text(kv.keys.first),
                );
              }).toList(),
              value: ref.watch(botTileProvider.notifier).selectedOrder,
              hint: const Text('Sort by'),
              icon: const Icon(Icons.sort),
              onChanged: (OrdersOrder? ordersOrder) {
                if (ordersOrder != null) {
                  ref.read(botTileProvider.notifier).orderBy(ordersOrder);
                }
              },
            ),
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          itemCount: allOrders.length,
          itemBuilder: (context, index) => ProviderScope(
            overrides: [
              currentOrdersPairTile.overrideWithValue(allOrders[index]),
            ],
            child: const BotTileOrdersPair(),
          ),
          separatorBuilder: (context, index) => const Divider(),
        ),
      ],
    );
  }
}
