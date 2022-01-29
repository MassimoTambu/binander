// GENERATED CODE - DO NOT MODIFY BY HAND

part of api;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      json['symbol'] as String,
      json['orderId'] as int,
      json['orderListId'] as int,
      json['clientOrderId'] as String,
      (json['price'] as num).toDouble(),
      (json['origQty'] as num).toDouble(),
      (json['executedQty'] as num).toDouble(),
      (json['cummulativeQuoteQty'] as num).toDouble(),
      $enumDecode(_$OrderStatusEnumMap, json['status']),
      $enumDecode(_$TimeInForceEnumMap, json['timeInForce']),
      $enumDecode(_$OrderTypesEnumMap, json['type']),
      $enumDecode(_$OrderSidesEnumMap, json['side']),
      (json['stopPrice'] as num).toDouble(),
      (json['icebergQty'] as num).toDouble(),
      json['time'] as int,
      json['updateTime'] as int,
      json['isWorking'] as bool,
      (json['origQuoteOrderQty'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'symbol': instance.symbol,
      'orderId': instance.orderId,
      'orderListId': instance.orderListId,
      'clientOrderId': instance.clientOrderId,
      'price': instance.price,
      'origQty': instance.origQty,
      'executedQty': instance.executedQty,
      'cummulativeQuoteQty': instance.cummulativeQuoteQty,
      'status': _$OrderStatusEnumMap[instance.status],
      'timeInForce': _$TimeInForceEnumMap[instance.timeInForce],
      'type': _$OrderTypesEnumMap[instance.type],
      'side': _$OrderSidesEnumMap[instance.side],
      'stopPrice': instance.stopPrice,
      'icebergQty': instance.icebergQty,
      'time': instance.time,
      'updateTime': instance.updateTime,
      'isWorking': instance.isWorking,
      'origQuoteOrderQty': instance.origQuoteOrderQty,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.NEW: 'NEW',
  OrderStatus.PARTIALLY_FILLED: 'PARTIALLY_FILLED',
  OrderStatus.FILLED: 'FILLED',
  OrderStatus.CANCELED: 'CANCELED',
  OrderStatus.PENDING_CANCEL: 'PENDING_CANCEL',
  OrderStatus.REJECTED: 'REJECTED',
  OrderStatus.EXPIRED: 'EXPIRED',
};

const _$TimeInForceEnumMap = {
  TimeInForce.GTC: 'GTC',
  TimeInForce.IOC: 'IOC',
  TimeInForce.FOK: 'FOK',
};

const _$OrderTypesEnumMap = {
  OrderTypes.LIMIT: 'LIMIT',
  OrderTypes.MARKET: 'MARKET',
  OrderTypes.STOP_LOSS: 'STOP_LOSS',
  OrderTypes.STOP_LOSS_LIMIT: 'STOP_LOSS_LIMIT',
  OrderTypes.TAKE_PROFIT: 'TAKE_PROFIT',
  OrderTypes.TAKE_PROFIT_LIMIT: 'TAKE_PROFIT_LIMIT',
  OrderTypes.LIMIT_MAKER: 'LIMIT_MAKER',
};

const _$OrderSidesEnumMap = {
  OrderSides.BUY: 'BUY',
  OrderSides.SELL: 'SELL',
};

OrderNew _$OrderNewFromJson(Map<String, dynamic> json) => OrderNew(
      json['symbol'] as String,
      json['orderId'] as int,
      json['orderListId'] as int,
      json['clientOrderId'] as String,
      json['transactTime'] as int,
      (json['price'] as num).toDouble(),
      (json['origQty'] as num).toDouble(),
      (json['executedQty'] as num).toDouble(),
      (json['cummulativeQuoteQty'] as num).toDouble(),
      $enumDecode(_$OrderStatusEnumMap, json['status']),
      $enumDecode(_$TimeInForceEnumMap, json['timeInForce']),
      $enumDecode(_$OrderTypesEnumMap, json['type']),
      $enumDecode(_$OrderSidesEnumMap, json['side']),
      (json['fills'] as List<dynamic>)
          .map((e) => Fill.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderNewToJson(OrderNew instance) => <String, dynamic>{
      'symbol': instance.symbol,
      'orderId': instance.orderId,
      'orderListId': instance.orderListId,
      'clientOrderId': instance.clientOrderId,
      'transactTime': instance.transactTime,
      'price': instance.price,
      'origQty': instance.origQty,
      'executedQty': instance.executedQty,
      'cummulativeQuoteQty': instance.cummulativeQuoteQty,
      'status': _$OrderStatusEnumMap[instance.status],
      'timeInForce': _$TimeInForceEnumMap[instance.timeInForce],
      'type': _$OrderTypesEnumMap[instance.type],
      'side': _$OrderSidesEnumMap[instance.side],
      'fills': instance.fills,
    };

Fill _$FillFromJson(Map<String, dynamic> json) => Fill(
      (json['price'] as num).toDouble(),
      (json['qty'] as num).toDouble(),
      (json['commission'] as num).toDouble(),
      json['commissionAsset'] as String,
      json['tradeId'] as int,
    );

Map<String, dynamic> _$FillToJson(Fill instance) => <String, dynamic>{
      'price': instance.price,
      'qty': instance.qty,
      'commission': instance.commission,
      'commissionAsset': instance.commissionAsset,
      'tradeId': instance.tradeId,
    };
