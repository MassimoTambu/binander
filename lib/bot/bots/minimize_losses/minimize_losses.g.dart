// GENERATED CODE - DO NOT MODIFY BY HAND

part of minimize_losses_bot;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MinimizeLossesConfig _$MinimizeLossesConfigFromJson(
        Map<String, dynamic> json) =>
    MinimizeLossesConfig(
      dailyLossSellOrders: json['dailyLossSellOrders'] as int?,
      maxInvestmentPerOrder:
          (json['maxInvestmentPerOrder'] as num?)?.toDouble(),
      percentageSellOrder: (json['percentageSellOrder'] as num?)?.toDouble(),
      symbol: json['symbol'] as String?,
      timerBuyOrder: json['timerBuyOrder'] == null
          ? null
          : Duration(microseconds: json['timerBuyOrder'] as int),
    );

Map<String, dynamic> _$MinimizeLossesConfigToJson(
        MinimizeLossesConfig instance) =>
    <String, dynamic>{
      'dailyLossSellOrders': instance.dailyLossSellOrders,
      'maxInvestmentPerOrder': instance.maxInvestmentPerOrder,
      'percentageSellOrder': instance.percentageSellOrder,
      'symbol': instance.symbol,
      'timerBuyOrder': instance.timerBuyOrder?.inMicroseconds,
    };

MinimizeLossesBot _$MinimizeLossesBotFromJson(Map<String, dynamic> json) =>
    MinimizeLossesBot(
      json['name'] as String,
      json['testNet'] as bool,
      MinimizeLossesConfig.fromJson(json['config'] as Map<String, dynamic>),
    )
      ..uuid = json['uuid'] as String
      ..type = $enumDecode(_$BotTypesEnumMap, json['type'])
      ..lastBuyOrder = json['lastBuyOrder'] == null
          ? null
          : OrderNew.fromJson(json['lastBuyOrder'] as Map<String, dynamic>)
      ..isBuyOrderCompleted = json['isBuyOrderCompleted'] as bool
      ..lastSellOrder = json['lastSellOrder'] == null
          ? null
          : OrderNew.fromJson(json['lastSellOrder'] as Map<String, dynamic>)
      ..lossSellOrderCounter = (json['lossSellOrderCounter'] as num).toDouble()
      ..cryptoInfo = json['cryptoInfo']
      ..ordersHistory = (json['ordersHistory'] as List<dynamic>)
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$MinimizeLossesBotToJson(MinimizeLossesBot instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'type': _$BotTypesEnumMap[instance.type],
      'testNet': instance.testNet,
      'config': instance.config,
      'name': instance.name,
      'lastBuyOrder': instance.lastBuyOrder,
      'isBuyOrderCompleted': instance.isBuyOrderCompleted,
      'lastSellOrder': instance.lastSellOrder,
      'lossSellOrderCounter': instance.lossSellOrderCounter,
      'cryptoInfo': instance.cryptoInfo,
      'ordersHistory': instance.ordersHistory,
    };

const _$BotTypesEnumMap = {
  BotTypes.minimizeLosses: 'minimizeLosses',
};
