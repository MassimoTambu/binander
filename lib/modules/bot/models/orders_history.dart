part of bot;

@JsonSerializable()
class OrdersHistory {
  // ignore: prefer_final_fields
  List<OrderPair> orders;

  OrdersHistory(this.orders);

  void add({required Order buyOrder, required Order sellOrder}) {
    orders.add(OrderPair(buyOrder: buyOrder, sellOrder: sellOrder));
  }

  factory OrdersHistory.fromJson(Map<String, dynamic> json) =>
      _$OrdersHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersHistoryToJson(this);
}
