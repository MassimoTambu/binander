part of bot;

@JsonSerializable()
class OrdersHistory {
  List<OrdersPair> orders;
  OrdersHistory(this.orders);

  Iterable<OrdersPair> get profitsOnly => orders.where((o) => o.isProfit);
  Iterable<OrdersPair> get lossesOnly => orders.where((o) => !o.isProfit);

  factory OrdersHistory.fromJson(Map<String, dynamic> json) =>
      _$OrdersHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersHistoryToJson(this);
}
