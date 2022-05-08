import 'package:bottino_fortino/api/api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'orders_pair.freezed.dart';

@freezed
class OrdersPair with _$OrdersPair {
  const OrdersPair._();
  const factory OrdersPair({required Order buyOrder, Order? sellOrder}) =
      _OrdersPair;

  /// Check whether is a profit or a loss orders pair
  bool get isProfit {
    if (sellOrder == null) return false;

    return sellOrder!.executedQty * sellOrder!.price >
        buyOrder.executedQty * buyOrder.price;
  }

  /// Returns the difference between sell order and buy order floor approximated starting from 2nd decimal number.
  /// If it's a loss orders pair the result wiil be a negative number
  double get gains {
    if (sellOrder == null) return 0;

    final gain = sellOrder!.cummulativeQuoteQty - buyOrder.cummulativeQuoteQty;
    return (gain * 100).floorToDouble() / 100;
  }

  factory OrdersPair.fromJson(Map<String, dynamic> json) =>
      _$OrdersPairFromJson(json);
}
