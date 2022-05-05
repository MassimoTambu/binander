part of bot;

@JsonSerializable()
class OrdersHistory {
  List<OrdersPair> orderPairs;
  List<OrdersPair> ordersCancelled;
  OrdersHistory(this.orderPairs, this.ordersCancelled);

  Iterable<OrdersPair> get profitsOnly => orderPairs.where((o) => o.isProfit);
  Iterable<OrdersPair> get lossesOnly => orderPairs.where((o) => !o.isProfit);

  Iterable<OrdersPair> get allOrders => orderPairs + ordersCancelled;

  /// Return the sum of all the orders pair. It could return a negative number
  double getTotalGains() =>
      orderPairs.map((o) => o.gains).reduce((acc, o) => acc + o);

  factory OrdersHistory.fromJson(Map<String, dynamic> json) =>
      _$OrdersHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersHistoryToJson(this);
}
