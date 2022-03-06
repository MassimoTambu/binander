part of bot;

class OrdersHistory {
  final List<Order> _orders;

  const OrdersHistory(this._orders);

  void add(Order order) {
    _orders.add(order);
  }
}
