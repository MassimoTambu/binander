// GENERATED CODE - DO NOT MODIFY BY HAND

part of bot;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersHistory _$OrdersHistoryFromJson(Map<String, dynamic> json) =>
    OrdersHistory(
      (json['orders'] as List<dynamic>)
          .map((e) => OrderPair.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrdersHistoryToJson(OrdersHistory instance) =>
    <String, dynamic>{
      'orders': instance.orders,
    };

OrderPair _$OrderPairFromJson(Map<String, dynamic> json) => OrderPair(
      buyOrder: Order.fromJson(json['buyOrder'] as Map<String, dynamic>),
      sellOrder: Order.fromJson(json['sellOrder'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderPairToJson(OrderPair instance) => <String, dynamic>{
      'buyOrder': instance.buyOrder,
      'sellOrder': instance.sellOrder,
    };
