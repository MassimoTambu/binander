part of bot;

@JsonSerializable()
class OrdersHistory {
  List<OrdersPair> ordersPair;
  List<OrdersPair> ordersCancelled;
  OrdersHistory(this.ordersPair, this.ordersCancelled);

  Iterable<OrdersPair> get profitsOnly => ordersPair.where((o) => o.isProfit);
  Iterable<OrdersPair> get lossesOnly => ordersPair.where((o) => !o.isProfit);

  Iterable<OrdersPair> get allOrders => ordersPair + ordersCancelled;

  /// Return the sum of all the orders pair. It could return a negative number
  double getTotalGains() =>
      ordersPair.map((o) => o.gains).reduce((acc, o) => acc + o);

  factory OrdersHistory.fromJson(Map<String, dynamic> json) =>
      _$OrdersHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersHistoryToJson(this);
}
