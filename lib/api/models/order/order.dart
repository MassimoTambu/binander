part of api;

@JsonSerializable()
class Order {
  final String symbol;
  final int orderId;
  final int orderListId;
  final String clientOrderId;
  final double price;
  final double origQty;
  final double executedQty;
  final double cummulativeQuoteQty;
  final OrderStatus status;
  final TimeInForce timeInForce;
  final OrderTypes type;
  final OrderSides side;
  final double stopPrice;
  final double icebergQty;
  @JsonKey(fromJson: ParseUtils.unixToDateTime)
  final DateTime time;
  @JsonKey(fromJson: ParseUtils.unixToDateTime)
  final DateTime updateTime;
  final bool isWorking;
  final double origQuoteOrderQty;

  Order(
    this.symbol,
    this.orderId,
    this.orderListId,
    this.clientOrderId,
    this.price,
    this.origQty,
    this.executedQty,
    this.cummulativeQuoteQty,
    this.status,
    this.timeInForce,
    this.type,
    this.side,
    this.stopPrice,
    this.icebergQty,
    this.time,
    this.updateTime,
    this.isWorking,
    this.origQuoteOrderQty,
  );

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
