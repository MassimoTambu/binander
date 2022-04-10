part of bot;

@freezed
class OrdersPair with _$OrdersPair {
  const OrdersPair._();
  const factory OrdersPair(
      {required Order buyOrder, required Order sellOrder}) = _OrdersPair;

  /// Check whether is a profit or a loss orders pair
  bool get isProfit {
    return sellOrder.executedQty * sellOrder.price >
        buyOrder.executedQty * buyOrder.price;
  }

  /// Returns the difference between sell order and buy order.
  /// If it's a loss orders pair the result wiil be a negative number
  double get gains {
    return sellOrder.executedQty * sellOrder.price -
        buyOrder.executedQty * buyOrder.price;
  }

  factory OrdersPair.fromJson(Map<String, dynamic> json) =>
      _$OrdersPairFromJson(json);
}
