part of bot;

final botProvider = StateNotifierProvider<BotProvider, List<Bot>>((ref) {
  return BotProvider();
});

class BotProvider extends StateNotifier<List<Bot>> {
  //TODO implement load bots
  BotProvider() : super([]);

  Bot createBot(
      Map<String, FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>>
          fields) {
    late final Bot bot;
    switch (fields['bot_type']!.value) {
      case BotTypes.minimizeLosses:
        bot = _createMinimizeLossesBot(fields);
        _saveMinimizeLossesBot(bot as MinimizeLossesBot);
        break;
      default:
        bot = _createMinimizeLossesBot(fields);
        _saveMinimizeLossesBot(bot as MinimizeLossesBot);
        break;
    }

    state = <Bot>[...state, bot];

    return bot;
  }

  MinimizeLossesBot _createMinimizeLossesBot(
      Map<String, FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>>
          fields) {
    return MinimizeLossesBot.create(
      name: fields['bot_name']!.value,
      dailyLossSellOrders: int.parse(
          fields[MinimizeLossesConfig.dailyLossSellOrdersName]!.value),
      maxInvestmentPerOrder: double.parse(
          fields[MinimizeLossesConfig.maxInvestmentPerOrderName]!.value),
      percentageSellOrder: double.parse(
          fields[MinimizeLossesConfig.percentageSellOrderName]!.value),
      timerBuyOrder: Duration(
        minutes:
            int.parse(fields[MinimizeLossesConfig.timerBuyOrderName]!.value),
      ),
    );
  }

  void _saveMinimizeLossesBot(MinimizeLossesBot bot) {
    //TODO implements saving
  }
}
