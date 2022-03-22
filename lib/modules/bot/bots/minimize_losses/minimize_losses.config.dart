// ignore_for_file: prefer_initializing_formals

part of minimize_losses_bot;

@JsonSerializable()
class MinimizeLossesConfig implements Config {
  int? dailyLossSellOrders;
  double? maxQuantityPerOrder;
  double? percentageSellOrder;
  String? symbol;
  Duration? timerBuyOrder;

  MinimizeLossesConfig({
    this.dailyLossSellOrders,
    this.maxQuantityPerOrder,
    this.percentageSellOrder,
    this.symbol,
    this.timerBuyOrder,
  });

  MinimizeLossesConfig.create({
    required int dailyLossSellOrders,
    required double maxQuantityPerOrder,
    required double percentageSellOrder,
    required String symbol,
    required Duration timerBuyOrder,
  }) {
    this.dailyLossSellOrders = dailyLossSellOrders;
    this.maxQuantityPerOrder = maxQuantityPerOrder;
    this.percentageSellOrder = percentageSellOrder;
    this.symbol = symbol;
    this.timerBuyOrder = timerBuyOrder;
    configFields[dailyLossSellOrdersName]!.value =
        dailyLossSellOrders.toString();
    configFields[maxInvestmentPerOrderName]!.value =
        maxQuantityPerOrder.toString();
    configFields[percentageSellOrderName]!.value =
        percentageSellOrder.toString();
    configFields[symbolName]!.value = symbol.toString();
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
    symbolName: SelectField(
      name: symbolName,
      publicName: symbolPublicName,
      description: symbolDescription,
      value: null,
      items: symbols,
      configFieldTypes: ConfigFieldTypes.selectField,
      validators: [
        ConfigFieldValidatorsTypes.required,
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
  static const String symbolName = 'symbol';
  static const String symbolPublicName = 'Crypto pair';
  static const String symbolDescription =
      "The crypto on the left will be used to buy the right one. NOTE: for TestNet use 'BTCUSDT' and 'BNBUSDT'";
  static const String timerBuyOrderName = 'timer_buy_order_name';
  static const String timerBuyOrderPublicName = 'Buy order timer';
  static const String timerBuyOrderDescription = '';

  factory MinimizeLossesConfig.fromJson(Map<String, dynamic> json) =>
      _$MinimizeLossesConfigFromJson(json);

  Map<String, dynamic> toJson() => _$MinimizeLossesConfigToJson(this);
}