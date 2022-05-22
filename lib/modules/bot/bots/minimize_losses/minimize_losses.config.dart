import 'package:bottino_fortino/models/config_field.dart';
import 'package:bottino_fortino/models/constants/symbols.dart';
import 'package:bottino_fortino/models/crypto_symbol.dart';
import 'package:bottino_fortino/models/enums/config_field_types.enum.dart';
import 'package:bottino_fortino/models/enums/config_field_validators_types.enum.dart';
import 'package:bottino_fortino/models/interfaces/config.interface.dart';
import 'package:bottino_fortino/models/select_field.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'minimize_losses.config.g.dart';

@JsonSerializable()
class MinimizeLossesConfig implements Config {
  int? dailyLossSellOrders;
  double? maxInvestmentPerOrder;
  double? percentageSellOrder;
  CryptoSymbol? symbol;
  Duration? timerBuyOrder;
  bool? autoRestart;

  MinimizeLossesConfig({
    this.dailyLossSellOrders,
    this.maxInvestmentPerOrder,
    this.percentageSellOrder,
    this.symbol,
    this.timerBuyOrder,
    this.autoRestart,
  });

  MinimizeLossesConfig.create({
    required this.dailyLossSellOrders,
    required this.maxInvestmentPerOrder,
    required this.percentageSellOrder,
    required this.symbol,
    required this.timerBuyOrder,
    required this.autoRestart,
  }) {
    configFields[dailyLossSellOrdersName]!.value =
        dailyLossSellOrders.toString();
    configFields[maxInvestmentPerOrderName]!.value =
        maxInvestmentPerOrder.toString();
    configFields[percentageSellOrderName]!.value =
        percentageSellOrder.toString();
    configFields[symbolName]!.value = symbol.toString();
    configFields[timerBuyOrderName]!.value =
        timerBuyOrder!.inMinutes.toString();
    configFields[autoRestartName]!.value = autoRestart!.toString();
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
    autoRestartName: SelectField(
      name: autoRestartName,
      publicName: autoRestartPublicName,
      description: autoRestartDescription,
      value: null,
      items: ['true', 'false'],
      configFieldTypes: ConfigFieldTypes.selectField,
      validators: [
        ConfigFieldValidatorsTypes.required,
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
  static const String maxInvestmentPerOrderDescription =
      "If you possess less than 'max investment per order' the bot will invest what you have";
  static const String percentageSellOrderName = 'percentage_sell_order';
  static const String percentageSellOrderPublicName = 'Sell order %';
  static const String percentageSellOrderDescription =
      'Percentage which bot will submit and move sell orders';
  static const String symbolName = 'symbol';
  static const String symbolPublicName = 'Crypto pair';
  static const String symbolDescription =
      "The crypto on the right will be used to buy the left one. NOTE: for TestNet use 'BTCUSDT' and 'BNBUSDT'";
  static const String timerBuyOrderName = 'timer_buy_order_name';
  static const String timerBuyOrderPublicName = 'Buy order timer';
  static const String timerBuyOrderDescription =
      'Time limit in minutes that the bot will try to submit a buy order';
  static const String autoRestartName = 'auto_restart_name';
  static const String autoRestartPublicName = 'Auto restart';
  static const String autoRestartDescription =
      'Auto restart bot when close a sell order';

  factory MinimizeLossesConfig.fromJson(Map<String, dynamic> json) =>
      _$MinimizeLossesConfigFromJson(json);

  Map<String, dynamic> toJson() => _$MinimizeLossesConfigToJson(this);
}
