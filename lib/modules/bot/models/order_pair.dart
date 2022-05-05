part of bot;

@freezed
class OrdersPair with _$OrdersPair {
  const OrdersPair._();
  const factory OrdersPair({
    required OrderData buyOrder,
    required OrderData sellOrder,
  }) = _OrdersPair;

  /// Check whether is a profit or a loss orders pair
  bool get isProfit {
    return sellOrder.executedQty * sellOrder.price >
        buyOrder.executedQty * buyOrder.price;
  }

  /// Returns the difference between sell order and buy order floor approximated starting from 2nd decimal number.
  /// If it's a loss orders pair the result wiil be a negative number
  double get gains {
    final gain = sellOrder.cummulativeQuoteQty - buyOrder.cummulativeQuoteQty;
    return (gain * 100).floorToDouble() / 100;
  }

  factory OrdersPair.fromJson(Map<String, dynamic> json) =>
      _$OrdersPairFromJson(json);
}
