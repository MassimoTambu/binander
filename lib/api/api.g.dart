// GENERATED CODE - DO NOT MODIFY BY HAND

part of api;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AveragePrice _$AveragePriceFromJson(Map<String, dynamic> json) => AveragePrice(
      json['mins'] as int,
      ParseUtils.stringToDouble(json['price'] as String),
    );

Map<String, dynamic> _$AveragePriceToJson(AveragePrice instance) =>
    <String, dynamic>{
      'mins': instance.mins,
      'price': instance.price,
    };

AccountInformation _$AccountInformationFromJson(Map<String, dynamic> json) =>
    AccountInformation(
      json['makerCommission'] as int,
      json['takerCommission'] as int,
      json['buyerCommission'] as int,
      json['sellerCommission'] as int,
      json['canTrade'] as bool,
      json['canWithdraw'] as bool,
      json['canDeposit'] as bool,
      ParseUtils.unixToDateTime(json['updateTime'] as int),
      json['accountType'] as String,
      (json['balances'] as List<dynamic>)
          .map((e) => AccountBalance.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['permissions'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AccountInformationToJson(AccountInformation instance) =>
    <String, dynamic>{
      'makerCommission': instance.makerCommission,
      'takerCommission': instance.takerCommission,
      'buyerCommission': instance.buyerCommission,
      'sellerCommission': instance.sellerCommission,
      'canTrade': instance.canTrade,
      'canWithdraw': instance.canWithdraw,
      'canDeposit': instance.canDeposit,
      'updateTime': instance.updateTime.toIso8601String(),
      'accountType': instance.accountType,
      'balances': instance.balances,
      'permissions': instance.permissions,
    };

AccountBalance _$AccountBalanceFromJson(Map<String, dynamic> json) =>
    AccountBalance(
      json['asset'] as String,
      ParseUtils.stringToDouble(json['free'] as String),
      ParseUtils.stringToDouble(json['locked'] as String),
    );

Map<String, dynamic> _$AccountBalanceToJson(AccountBalance instance) =>
    <String, dynamic>{
      'asset': instance.asset,
      'free': instance.free,
      'locked': instance.locked,
    };

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
      ParseUtils.unixToDateTime(json['time'] as int),
      ParseUtils.unixToDateTime(json['updateTime'] as int),
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
      'time': instance.time.toIso8601String(),
      'updateTime': instance.updateTime.toIso8601String(),
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

OrderCancel _$OrderCancelFromJson(Map<String, dynamic> json) => OrderCancel(
      json['symbol'] as String,
      json['orderId'] as int,
      json['orderListId'] as int,
      json['clientOrderId'] as String,
      ParseUtils.unixToDateTime(json['transactTime'] as int),
      ParseUtils.stringToDouble(json['price'] as String),
      ParseUtils.stringToDouble(json['origQty'] as String),
      ParseUtils.stringToDouble(json['executedQty'] as String),
      ParseUtils.stringToDouble(json['cummulativeQuoteQty'] as String),
      $enumDecode(_$OrderStatusEnumMap, json['status']),
      $enumDecode(_$TimeInForceEnumMap, json['timeInForce']),
      $enumDecode(_$OrderTypesEnumMap, json['type']),
      $enumDecode(_$OrderSidesEnumMap, json['side']),
    );

Map<String, dynamic> _$OrderCancelToJson(OrderCancel instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'orderId': instance.orderId,
      'orderListId': instance.orderListId,
      'clientOrderId': instance.clientOrderId,
      'transactTime': instance.transactTime.toIso8601String(),
      'price': instance.price,
      'origQty': instance.origQty,
      'executedQty': instance.executedQty,
      'cummulativeQuoteQty': instance.cummulativeQuoteQty,
      'status': _$OrderStatusEnumMap[instance.status],
      'timeInForce': _$TimeInForceEnumMap[instance.timeInForce],
      'type': _$OrderTypesEnumMap[instance.type],
      'side': _$OrderSidesEnumMap[instance.side],
    };

Fill _$FillFromJson(Map<String, dynamic> json) => Fill(
      ParseUtils.stringToDouble(json['price'] as String),
      ParseUtils.stringToDouble(json['qty'] as String),
      ParseUtils.stringToDouble(json['commission'] as String),
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

OrderNew _$OrderNewFromJson(Map<String, dynamic> json) => OrderNew(
      json['symbol'] as String,
      json['orderId'] as int,
      json['orderListId'] as int,
      json['clientOrderId'] as String,
      ParseUtils.unixToDateTime(json['transactTime'] as int),
      ParseUtils.stringToDouble(json['price'] as String),
      ParseUtils.stringToDouble(json['origQty'] as String),
      ParseUtils.stringToDouble(json['executedQty'] as String),
      ParseUtils.stringToDouble(json['cummulativeQuoteQty'] as String),
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
      'transactTime': instance.transactTime.toIso8601String(),
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
