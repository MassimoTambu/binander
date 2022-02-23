part of api;

@JsonSerializable()
class OrderCancel {
  final String symbol;
  final int orderId;
  final int orderListId;
  final String clientOrderId;
  @JsonKey(fromJson: ParseUtils.unixToDateTime)
  final DateTime transactTime;
  @JsonKey(fromJson: ParseUtils.stringToDouble)
  final double price;
  @JsonKey(fromJson: ParseUtils.stringToDouble)
  final double origQty;
  @JsonKey(fromJson: ParseUtils.stringToDouble)
  final double executedQty;
  @JsonKey(fromJson: ParseUtils.stringToDouble)
  final double cummulativeQuoteQty;
  final OrderStatus status;
  final TimeInForce timeInForce;
  final OrderTypes type;
  final OrderSides side;

  const OrderCancel(
    this.symbol,
    this.orderId,
    this.orderListId,
    this.clientOrderId,
    this.transactTime,
    this.price,
    this.origQty,
    this.executedQty,
    this.cummulativeQuoteQty,
    this.status,
    this.timeInForce,
    this.type,
    this.side,
  );

  factory OrderCancel.fromJson(Map<String, dynamic> json) =>
      _$OrderCancelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderCancelToJson(this);
}
