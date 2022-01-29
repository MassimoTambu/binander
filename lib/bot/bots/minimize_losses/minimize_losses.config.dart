// ignore_for_file: prefer_initializing_formals

part of minimize_losses_bot;

@JsonSerializable()
class MinimizeLossesConfig implements Config {
  int? dailyLossSellOrders;
  double? maxInvestmentPerOrder;
  double? percentageSellOrder;
  Duration? timerBuyOrder;

  MinimizeLossesConfig({
    this.dailyLossSellOrders,
    this.maxInvestmentPerOrder,
    this.percentageSellOrder,
    this.timerBuyOrder,
  });

  MinimizeLossesConfig.create({
    required int dailyLossSellOrders,
    required double maxInvestmentPerOrder,
    required double percentageSellOrder,
    required Duration timerBuyOrder,
  }) {
    this.dailyLossSellOrders = dailyLossSellOrders;
    this.maxInvestmentPerOrder = maxInvestmentPerOrder;
    this.percentageSellOrder = percentageSellOrder;
    this.timerBuyOrder = timerBuyOrder;
    configFields[dailyLossSellOrdersName]!.value =
        dailyLossSellOrders.toString();
    configFields[maxInvestmentPerOrderName]!.value =
        maxInvestmentPerOrder.toString();
    configFields[percentageSellOrderName]!.value =
        percentageSellOrder.toString();
    configFields[timerBuyOrderName]!.value = timerBuyOrder.inMinutes.toString();
  }

  @override
  final Map<String, ConfigField> configFields = {
    dailyLossSellOrdersName: ConfigField(
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
    maxInvestmentPerOrderName: ConfigField(
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
    percentageSellOrderName: ConfigField(
      name: percentageSellOrderName,
      publicName: percentageSellOrderPublicName,
      description: percentageSellOrderDescription,
      value: null,
      configFieldTypes: ConfigFieldTypes.textField,
      validators: [
        ConfigFieldValidatorsTypes.required,
        ConfigFieldValidatorsTypes.double,
        ConfigFieldValidatorsTypes.positiveNumbers,
        ConfigFieldValidatorsTypes.min1,
      ],
    ),
    timerBuyOrderName: ConfigField(
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

  factory MinimizeLossesConfig.fromJson(Map<String, dynamic> json) =>
      _$MinimizeLossesConfigFromJson(json);

  Map<String, dynamic> toJson() => _$MinimizeLossesConfigToJson(this);
}
