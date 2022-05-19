import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/modules/bot/models/roi.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'run_orders.freezed.dart';
part 'run_orders.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class RunOrders with _$RunOrders {
  const RunOrders._();
  const factory RunOrders(
    List<OrderData> orders, {
    @Default(false) bool hasEnded,
  }) = _RunOrders;

  /// Returns the buy order found. Should always be no more than one buy order
  OrderData? get buyOrder {
    final buyOrders = orders.where((o) => o.side == OrderSides.BUY);
    if (buyOrders.isEmpty) return null;

    return buyOrders.first;
  }

  /// Returns the last sell order found.
  /// Could exists more than one sell order like cancelled sell orders
  OrderData? get sellOrder {
    // Should always be one
    final sellOrders = orders.where((o) => o.side == OrderSides.SELL);
    if (sellOrders.isEmpty) return null;

    return sellOrders.last;
  }

  /// Check whether is a profit or a loss orders pair
  ROI get roi {
    if ((buyOrder == null && sellOrder == null) ||
        buyOrder == null ||
        sellOrder == null) {
      return ROI.stable;
    }

    if (sellOrder!.executedQty * sellOrder!.price >
        buyOrder!.executedQty * buyOrder!.price) {
      return ROI.profit;
    }

    return ROI.loss;
  }

  /// Returns the difference between sell order and buy order floor approximated starting from 2nd decimal number.
  /// If it's a loss orders pair the result wiil be a negative number
  double get gains {
    if (buyOrder == null || sellOrder == null) return 0;

    final gain = sellOrder!.cummulativeQuoteQty - buyOrder!.cummulativeQuoteQty;
    return (gain * 100).floorToDouble() / 100;
  }

  factory RunOrders.fromJson(Map<String, dynamic> json) =>
      _$RunOrdersFromJson(json);
}
