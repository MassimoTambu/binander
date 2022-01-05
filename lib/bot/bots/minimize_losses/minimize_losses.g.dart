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
      'timerBuyOrder': instance.timerBuyOrder?.inMicroseconds,
    };

MinimizeLossesBot _$MinimizeLossesBotFromJson(Map<String, dynamic> json) =>
    MinimizeLossesBot(
      json['name'] as String,
      MinimizeLossesStrategy.fromJson(json['strategy'] as Map<String, dynamic>),
      MinimizeLossesConfig.fromJson(json['config'] as Map<String, dynamic>),
    )
      ..uuid = json['uuid'] as String
      ..type = $enumDecode(_$BotTypesEnumMap, json['type']);

Map<String, dynamic> _$MinimizeLossesBotToJson(MinimizeLossesBot instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'type': _$BotTypesEnumMap[instance.type],
      'config': instance.config,
      'name': instance.name,
      'strategy': MinimizeLossesStrategy.toJson(instance.strategy),
    };

const _$BotTypesEnumMap = {
  BotTypes.minimizeLosses: 'minimizeLosses',
};
