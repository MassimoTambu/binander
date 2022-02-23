part of api;

@JsonSerializable()
class OrderNew {
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
  final List<Fill> fills;

  const OrderNew(
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
    this.fills,
  );

  factory OrderNew.fromJson(Map<String, dynamic> json) =>
      _$OrderNewFromJson(json);

  Map<String, dynamic> toJson() => _$OrderNewToJson(this);
}
