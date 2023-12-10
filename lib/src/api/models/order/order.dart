part of '../../api.dart';

@freezed
class Order with _$Order {
  const Order._();
  const factory Order.data(
    String symbol,
    int orderId,
    int orderListId,
    String clientOrderId,
    @JsonKey(
        fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
    double price,
    @JsonKey(
        fromJson: ParseUtils.nullStringToDouble,
        toJson: ParseUtils.nullDoubleToString)
    double? stopPrice,

    /// Original quantity inserted when order was submitted by user (OrderStatus = NEW)
    @JsonKey(
        fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
    double origQty,

    /// Actual executed quantity
    @JsonKey(
        fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
    double executedQty,

    /// Is the multiplication between executedQty and price
    @JsonKey(
        fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
    double cummulativeQuoteQty,
    OrderStatus status,
    TimeInForce timeInForce,
    OrderTypes type,
    OrderSides side,
    @JsonKey(
        fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
    double icebergQty,
    @JsonKey(
        fromJson: ParseUtils.unixToDateTime, toJson: ParseUtils.dateTimeToUnix)
    DateTime time,
    @JsonKey(
        fromJson: ParseUtils.unixToDateTime, toJson: ParseUtils.dateTimeToUnix)
    DateTime updateTime,
    bool isWorking,
    @JsonKey(
        fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
    double origQuoteOrderQty,
    SelfTradePreventionMode selfTradePreventionMode,
  ) = OrderData;

  const factory Order.newLimit(
    String symbol,
    int orderId,
    int orderListId,
    String clientOrderId,
    @JsonKey(
        fromJson: ParseUtils.unixToDateTime, toJson: ParseUtils.dateTimeToUnix)
    DateTime transactTime,
    @JsonKey(
        fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
    double price,

    /// Original quantity inserted when order was submitted by user (OrderStatus = NEW)
    @JsonKey(
        fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
    double origQty,

    /// Actual executed quantity
    @JsonKey(
        fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
    double executedQty,

    /// Is the multiplication between executedQty and price
    @JsonKey(
        fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
    double cummulativeQuoteQty,
    OrderStatus status,
    TimeInForce timeInForce,
    OrderTypes type,
    OrderSides side,
    SelfTradePreventionMode selfTradePreventionMode,
    List<Fill> fills,
  ) = OrderNewLimit;

  const factory Order.cancel(
    String symbol,
    int orderId,
    int orderListId,
    String clientOrderId,
    String origClientOrderId,
    @JsonKey(
        fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
    double price,
    @JsonKey(
        fromJson: ParseUtils.nullStringToDouble,
        toJson: ParseUtils.nullDoubleToString)
    double? stopPrice,

    /// Original quantity inserted when order was submitted by user (OrderStatus = NEW)
    @JsonKey(
        fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
    double origQty,

    /// Actual executed quantity
    @JsonKey(
        fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
    double executedQty,

    /// Is the multiplication between executedQty and price
    @JsonKey(
        fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
    double cummulativeQuoteQty,
    OrderStatus status,
    TimeInForce timeInForce,
    OrderTypes type,
    OrderSides side,
    SelfTradePreventionMode selfTradePreventionMode,
  ) = OrderCancel;

  /// Is the average price the order has been filled
  double get cummulativeQuotePrice => cummulativeQuoteQty / executedQty;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
