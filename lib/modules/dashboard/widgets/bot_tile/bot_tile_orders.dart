part of dashboard_module;

class BotTileDetails extends ConsumerWidget {
  const BotTileDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOrders = ref
        .watch(botTileProvider)
        .pipeline
        .bot
        .pipelineData
        .ordersHistory
        .allOrders;
    const items = ['Date (newer)', 'Date (oldest)', 'Gains', 'Losses'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // DropdownButton(
            //   items: items.map<DropdownMenuItem<String>>((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            //   value: items.first,
            //   hint: const Text('Sort by'),
            //   icon: const Icon(Icons.sort),
            //   onChanged: (e) {},
            // ),
          ],
        ),
      ],
    );
  }
}
