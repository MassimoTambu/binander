part of bot;

@freezed
class OrdersHistory with _$OrdersHistory {
  const OrdersHistory._();
  //TODO forse dovrò rimuovere const per via della List
  const factory OrdersHistory(List<OrderPair> orders) = _OrdersHistory;

  void add({required Order buyOrder, required Order sellOrder}) {
    orders.add(OrderPair(buyOrder: buyOrder, sellOrder: sellOrder));
  }

  factory OrdersHistory.fromJson(Map<String, dynamic> json) =>
      _$OrdersHistoryFromJson(json);
}
