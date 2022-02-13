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
      ..buyOrderPrice = (json['buyOrderPrice'] as num?)?.toDouble()
      ..isBuyOrderCompleted = json['isBuyOrderCompleted'] as bool
      ..lastSellOrderPrice = (json['lastSellOrderPrice'] as num?)?.toDouble()
      ..sellOrderId = json['sellOrderId'] as int?
      ..lossSellOrderCounter = (json['lossSellOrderCounter'] as num).toDouble()
      ..cryptoInfo = json['cryptoInfo']
      ..ordersHistory = json['ordersHistory'];

Map<String, dynamic> _$MinimizeLossesBotToJson(MinimizeLossesBot instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'type': _$BotTypesEnumMap[instance.type],
      'testNet': instance.testNet,
      'config': instance.config,
      'name': instance.name,
      'buyOrderPrice': instance.buyOrderPrice,
      'isBuyOrderCompleted': instance.isBuyOrderCompleted,
      'lastSellOrderPrice': instance.lastSellOrderPrice,
      'sellOrderId': instance.sellOrderId,
      'lossSellOrderCounter': instance.lossSellOrderCounter,
      'cryptoInfo': instance.cryptoInfo,
      'ordersHistory': instance.ordersHistory,
    };

const _$BotTypesEnumMap = {
  BotTypes.minimizeLosses: 'minimizeLosses',
};
