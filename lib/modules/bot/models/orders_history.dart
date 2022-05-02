part of bot;

@JsonSerializable()
class OrdersHistory {
  List<OrdersPair> orders;
  OrdersHistory(this.orders);

  Iterable<OrdersPair> get profitsOnly => orders.where((o) => o.isProfit);
  Iterable<OrdersPair> get lossesOnly => orders.where((o) => !o.isProfit);

  /// Return the sum of all the orders pair. It could return a negative number
  double getTotalGains() =>
      orders.map((o) => o.gains).reduce((acc, o) => acc + o);

  factory OrdersHistory.fromJson(Map<String, dynamic> json) =>
      _$OrdersHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersHistoryToJson(this);
}
