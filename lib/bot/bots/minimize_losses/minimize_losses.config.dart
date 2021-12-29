part of minimize_losses_bot;

class MinimizeLossesConfig implements Config {
  static final Map<String, ConfigField> configFields = {
    dailyLossSellOrdersName: ConfigField<int>(
      name: dailyLossSellOrdersName,
      publicName: dailyLossSellOrdersPublicName,
      description: dailyLossSellOrdersDescription,
      value: null,
      configFieldTypes: ConfigFieldTypes.textField,
      validators: [
        ConfigFieldValidatorsTypes.required,
        ConfigFieldValidatorsTypes.int,
        ConfigFieldValidatorsTypes.positiveNumbers,
      ],
    ),
    maxInvestmentPerOrderName: ConfigField<double>(
      name: maxInvestmentPerOrderName,
      publicName: maxInvestmentPerOrderPublicName,
      description: maxInvestmentPerOrderDescription,
      value: null,
      configFieldTypes: ConfigFieldTypes.textField,
      validators: [
        ConfigFieldValidatorsTypes.required,
        ConfigFieldValidatorsTypes.double,
        ConfigFieldValidatorsTypes.positiveNumbers,
      ],
    ),
    percentageSellOrderName: ConfigField<double>(
      name: percentageSellOrderName,
      publicName: percentageSellOrderPublicName,
      description: percentageSellOrderDescription,
      value: null,
      configFieldTypes: ConfigFieldTypes.textField,
      validators: [
        ConfigFieldValidatorsTypes.required,
        ConfigFieldValidatorsTypes.double,
        ConfigFieldValidatorsTypes.positiveNumbers,
      ],
    ),
    timerBuyOrderName: ConfigField<Duration>(
      name: timerBuyOrderName,
      publicName: timerBuyOrderPublicName,
      description: timerBuyOrderDescription,
      value: null,
      configFieldTypes: ConfigFieldTypes.textField,
      validators: [
        ConfigFieldValidatorsTypes.required,
        ConfigFieldValidatorsTypes.int,
        ConfigFieldValidatorsTypes.positiveNumbers,
      ],
    ),
  };

  MinimizeLossesConfig.create({
    required int dailyLossSellOrders,
    required double maxInvestmentPerOrder,
    required double percentageSellOrder,
    required Duration timerBuyOrder,
  }) {
    configFields[dailyLossSellOrdersName]!.value = dailyLossSellOrders;
    configFields[maxInvestmentPerOrderName]!.value = maxInvestmentPerOrder;
    configFields[percentageSellOrderName]!.value = percentageSellOrder;
    configFields[timerBuyOrderName]!.value = timerBuyOrder;
  }

  @override
  Map<String, ConfigField> get configFieldsData => configFields;

  // Data
  static const String dailyLossSellOrdersName = 'daily_loss_sell_orders';
  static const String dailyLossSellOrdersPublicName =
      'Max daily loss sell orders';
  static const String dailyLossSellOrdersDescription = '';
  static const String maxInvestmentPerOrderName = 'max_investment_per_order';
  static const String maxInvestmentPerOrderPublicName =
      'Max investment per order';
  static const String maxInvestmentPerOrderDescription = '';
  static const String percentageSellOrderName = 'percentage_sell_order';
  static const String percentageSellOrderPublicName = 'Sell order %';
  static const String percentageSellOrderDescription = '';
  static const String timerBuyOrderName = 'timer_buy_order_name';
  static const String timerBuyOrderPublicName = 'Buy order timer';
  static const String timerBuyOrderDescription = '';
}
