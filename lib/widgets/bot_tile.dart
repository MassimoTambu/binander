part of widgets;

class BotTile extends StatelessWidget {
  final Bot bot;

  const BotTile({Key? key, required this.bot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          BotTileChips(testNet: bot.testNet, botStatus: bot.status)
        ],
      ),
    );
  }
}
