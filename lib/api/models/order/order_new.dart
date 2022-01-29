part of api;

@JsonSerializable()
class OrderNew {
  final String symbol;
  final int orderId;
  final int orderListId;
  final String clientOrderId;
  final int transactTime;
  final double price;
  final double origQty;
  final double executedQty;
  final double cummulativeQuoteQty;
  final OrderStatus status;
  final TimeInForce timeInForce;
  final OrderTypes type;
  final OrderSides side;
  final List<Fill> fills;

  OrderNew(
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

@JsonSerializable()
class Fill {
  final double price;
  final double qty;
  final double commission;
  final String commissionAsset;
  final int tradeId;

  Fill(
    this.price,
    this.qty,
    this.commission,
    this.commissionAsset,
    this.tradeId,
  );

  factory Fill.fromJson(Map<String, dynamic> json) => _$FillFromJson(json);

  Map<String, dynamic> toJson() => _$FillToJson(this);
}
