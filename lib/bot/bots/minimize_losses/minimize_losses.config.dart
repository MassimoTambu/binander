part of minimize_losses_bot;

class MinimizeLossesConfig implements Config {
  static final Map<String, BotConfigField> configFields = {
    dailyLossSellOrdersName: BotConfigField(
      name: dailyLossSellOrdersName,
      publicName: dailyLossSellOrdersPublicName,
      description: dailyLossSellOrdersDescription,
      value: null,
    ),
    maxInvestmentPerOrderName: BotConfigField(
      name: maxInvestmentPerOrderName,
      publicName: maxInvestmentPerOrderPublicName,
      description: maxInvestmentPerOrderDescription,
      value: null,
    ),
    percentageSellOrderName: BotConfigField(
      name: percentageSellOrderName,
      publicName: percentageSellOrderPublicName,
      description: percentageSellOrderDescription,
      value: null,
    ),
    timerBuyOrderName: BotConfigField(
      name: timerBuyOrderName,
      publicName: timerBuyOrderPublicName,
      description: timerBuyOrderDescription,
      value: null,
    ),
  };

  MinimizeLossesConfig.create({
    required int dailyLossSellOrders,
    required int maxInvestmentPerOrder,
    required double percentageSellOrder,
    required Duration timerBuyOrder,
  }) {
    configFields[dailyLossSellOrdersName]!.value = dailyLossSellOrders;
    configFields[maxInvestmentPerOrderName]!.value = maxInvestmentPerOrder;
    configFields[percentageSellOrderName]!.value = percentageSellOrder;
    configFields[timerBuyOrderName]!.value = timerBuyOrder;
  }

  @override
  Map<String, BotConfigField> get configFieldsData => configFields;

  // Data
  static const String dailyLossSellOrdersName = 'dailyLossSellOrders';
  static const String dailyLossSellOrdersPublicName =
      'Max daily loss sell orders';
  static const String dailyLossSellOrdersDescription = '';
  static const String maxInvestmentPerOrderName = 'maxInvestmentPerOrder';
  static const String maxInvestmentPerOrderPublicName =
      'Max investment per order';
  static const String maxInvestmentPerOrderDescription = '';
  static const String percentageSellOrderName = 'percentageSellOrder';
  static const String percentageSellOrderPublicName = 'Sell order %';
  static const String percentageSellOrderDescription = '';
  static const String timerBuyOrderName = 'timerBuyOrderName';
  static const String timerBuyOrderPublicName = 'Buy order timer';
  static const String timerBuyOrderDescription = '';
}
