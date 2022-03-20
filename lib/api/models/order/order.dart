part of api;

@JsonSerializable()
class Order {
  final String symbol;
  final int orderId;
  final int orderListId;
  final String clientOrderId;
  @JsonKey(
      fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
  final double price;
  @JsonKey(
      fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
  final double origQty;
  @JsonKey(
      fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
  final double executedQty;
  @JsonKey(
      fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
  final double cummulativeQuoteQty;
  final OrderStatus status;
  final TimeInForce timeInForce;
  final OrderTypes type;
  final OrderSides side;
  @JsonKey(
      fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
  final double stopPrice;
  @JsonKey(
      fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
  final double icebergQty;
  @JsonKey(
      fromJson: ParseUtils.unixToDateTime, toJson: ParseUtils.dateTimeToUnix)
  final DateTime time;
  @JsonKey(
      fromJson: ParseUtils.unixToDateTime, toJson: ParseUtils.dateTimeToUnix)
  final DateTime updateTime;
  final bool isWorking;
  @JsonKey(
      fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
  final double origQuoteOrderQty;

  const Order(
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
