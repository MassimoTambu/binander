part of bot;

class BotService {
  static final _singleton = BotService._internal();

  factory BotService() {
    return _singleton;
  }

  BotService._internal();

  Bot createBot(
      Map<String, FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>>
          fields) {
    switch (fields['bot_type']!.value) {
      case BotTypes.minimizeLosses:
        return _createMinimizeLossesBot(fields);
      default:
        return _createMinimizeLossesBot(fields);
    }
  }

  Bot _createMinimizeLossesBot(
      Map<String, FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>>
          fields) {
    return MinimizeLossesBot.create(
      name: fields['bot_name']!.value,
      dailyLossSellOrders: int.parse(fields['daily_loss_sell_orders']!.value),
      maxInvestmentPerOrder:
          double.parse(fields['max_investment_per_order']!.value),
      percentageSellOrder: double.parse(fields['percentage_sell_order']!.value),
      timerBuyOrder:
          Duration(minutes: int.parse(fields['timer_buy_order_name']!.value)),
    );
  }
}
