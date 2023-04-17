import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/bot/domain/roi.dart';
import 'package:binander/src/features/bot/domain/run_orders.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'orders_history.freezed.dart';
part 'orders_history.g.dart';

@unfreezed
class OrdersHistory with _$OrdersHistory {
  const OrdersHistory._();
  factory OrdersHistory(
    List<RunOrders> runOrders,
  ) = _OrdersHistory;

  RunOrders? get lastNotEndedRunOrders {
    final runOrder = runOrders.where((ro) => !ro.hasEnded);
    if (runOrder.isEmpty) return null;
    return runOrder.last;
  }

  Iterable<RunOrders> get profitsOnly =>
      runOrders.where((ro) => ro.roi == ROI.profit);
  Iterable<RunOrders> get lossesOnly =>
      runOrders.where((ro) => ro.roi == ROI.loss);

  Iterable<OrderData> get allOrders => runOrders
      .map((ro) => ro.orders)
      .fold<List<OrderData>>([], (acc, ro) => acc + ro);

  Iterable<OrderData> get cancelledOrders => runOrders
      .map((ro) => ro.orders)
      .fold<List<OrderData>>([], (acc, ro) => acc + ro).where(
          (o) => o.status == OrderStatus.CANCELED);

  void upsertOrderInNotEndedRunOrder(OrderData order) {
    if (lastNotEndedRunOrders == null) {
      return runOrders.add(RunOrders([order]));
    }

    // Insert
    if (lastNotEndedRunOrders!.orders
        .where((o) => o.orderId == order.orderId)
        .isEmpty) {
      return lastNotEndedRunOrders!.orders.add(order);
    }

    // Update
    lastNotEndedRunOrders!.orders
        .removeWhere((o) => o.orderId == order.orderId);
    lastNotEndedRunOrders!.orders.add(order);
  }

  void closeRunOrder() {
    runOrders = runOrders.map(
      (ro) {
        if (ro.hashCode == lastNotEndedRunOrders.hashCode) {
          return ro.copyWith(hasEnded: true);
        }

        return ro;
      },
    ).toList();
  }

  /// Return the sum of all the orders pair. It could return a negative number
  double getTotalGains() =>
      runOrders.map((ro) => ro.gains).fold<double>(0, (acc, g) => acc + g);

  factory OrdersHistory.fromJson(Map<String, dynamic> json) =>
      _$OrdersHistoryFromJson(json);
}
