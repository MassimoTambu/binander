part of api;

@freezed
class Order with _$Order {
  const factory Order.data(
    String symbol,
    int orderId,
    int orderListId,
    String clientOrderId,
    @JsonKey(fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
        double price,
    @JsonKey(fromJson: ParseUtils.nullStringToDouble, toJson: ParseUtils.nullDoubleToString)
        double? stopPrice,

    /// Original quantity inserted when order was submitted by user (OrderStatus = NEW)
    @JsonKey(fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
        double origQty,

    /// Actual executed quantity
    @JsonKey(fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
        double executedQty,

    /// Is the multiplication between executedQty and price
    @JsonKey(fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
        double cummulativeQuoteQty,
    OrderStatus status,
    TimeInForce timeInForce,
    OrderTypes type,
    OrderSides side,
    @JsonKey(fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
        double icebergQty,
    @JsonKey(fromJson: ParseUtils.unixToDateTime, toJson: ParseUtils.dateTimeToUnix)
        DateTime time,
    @JsonKey(fromJson: ParseUtils.unixToDateTime, toJson: ParseUtils.dateTimeToUnix)
        DateTime updateTime,
    bool isWorking,
    @JsonKey(fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
        double origQuoteOrderQty,
  ) = OrderData;

  const factory Order.newLimit(
    String symbol,
    int orderId,
    int orderListId,
    String clientOrderId,
    @JsonKey(fromJson: ParseUtils.unixToDateTime, toJson: ParseUtils.dateTimeToUnix)
        DateTime transactTime,
    @JsonKey(fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
        double price,

    /// Original quantity inserted when order was submitted by user (OrderStatus = NEW)
    @JsonKey(fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
        double origQty,

    /// Actual executed quantity
    @JsonKey(fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
        double executedQty,

    /// Is the multiplication between executedQty and price
    @JsonKey(fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
        double cummulativeQuoteQty,
    OrderStatus status,
    TimeInForce timeInForce,
    OrderTypes type,
    OrderSides side,
    List<Fill> fills,
  ) = OrderNewLimit;

  const factory Order.cancel(
    String symbol,
    int orderId,
    int orderListId,
    String clientOrderId,
    @JsonKey(fromJson: ParseUtils.unixToDateTime, toJson: ParseUtils.dateTimeToUnix)
        DateTime transactTime,
    @JsonKey(fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
        double price,
    @JsonKey(fromJson: ParseUtils.nullStringToDouble, toJson: ParseUtils.nullDoubleToString)
        double? stopPrice,

    /// Original quantity inserted when order was submitted by user (OrderStatus = NEW)
    @JsonKey(fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
        double origQty,

    /// Actual executed quantity
    @JsonKey(fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
        double executedQty,

    /// Is the multiplication between executedQty and price
    @JsonKey(fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
        double cummulativeQuoteQty,
    OrderStatus status,
    TimeInForce timeInForce,
    OrderTypes type,
    OrderSides side,
  ) = OrderCancel;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
