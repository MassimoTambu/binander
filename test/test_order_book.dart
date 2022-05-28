import 'package:binander/api/api.dart';

import 'test_utils.dart';
import 'test_wallet.dart';

class TestOrderBook {
  final List<OrderData> orders;
  int ordersCount;
  double Function() getPriceStrategy;

  TestOrderBook.create({
    required this.orders,
    required this.getPriceStrategy,
    this.ordersCount = 0,
  });

  void reset() {
    orders.removeWhere((_) => true);
    ordersCount = 0;
    getPriceStrategy = () => 0.0;
  }

  OrderNewLimit addNewLimitOrder(
    TestWallet wallet, {
    required double price,
    required double origQty,
  }) {
    ordersCount++;
    final buyOrder = TestUtils.createOrderNewLimit(
        orderId: ordersCount,
        orderListId: ordersCount,
        clientOrderId: '$ordersCount',
        price: price,
        origQty: origQty,
        orderSides: OrderSides.BUY);

    wallet.balances = wallet.balances.map((b) {
      if (buyOrder.symbol.endsWith(b.asset)) {
        final cummulativeQuoteQty = buyOrder.price * buyOrder.origQty;
        return b.copyWith(
          free: b.free - cummulativeQuoteQty,
          locked: b.locked + cummulativeQuoteQty,
        );
      }
      return b;
    }).toList();

    orders.add(TestUtils.createOrderDataFromNewLimit(buyOrder));

    return buyOrder;
  }

  OrderNewStopLimit addNewStopLimitOrder(
    TestWallet wallet, {
    required double price,
    required double stopPrice,
    required double origQty,
  }) {
    ordersCount++;
    final stopSellOrder = TestUtils.createOrderNewStopLimit(
        orderId: ordersCount,
        orderListId: ordersCount,
        clientOrderId: '$ordersCount');

    final sellOrderData = TestUtils.createOrderDataFromNewStopLimit(
        stopSellOrder, price, stopPrice, origQty, OrderSides.SELL);

    wallet.balances = wallet.balances.map((b) {
      if (stopSellOrder.symbol.startsWith(b.asset)) {
        return b.copyWith(
          free: b.free - sellOrderData.origQty,
          locked: b.locked + sellOrderData.origQty,
        );
      }
      return b;
    }).toList();

    orders.add(sellOrderData);

    return stopSellOrder;
  }

  OrderData updateOrder(TestWallet wallet, int orderId) {
    final order = orders.where((o) => o.orderId == orderId).map((o) {
      if (o.status == OrderStatus.FILLED) return o;

      if (_shouldFillOrder(o)) {
        final updatedOrderData = o.copyWith(
            status: OrderStatus.FILLED,
            cummulativeQuoteQty: o.origQty * o.price,
            executedQty: o.origQty);

        wallet.balances = wallet.balances.map((b) {
          // Check whether balance has been used in this order and if so update the account wallet
          if (updatedOrderData.side == OrderSides.BUY) {
            if (updatedOrderData.symbol.startsWith(b.asset)) {
              return b.copyWith(free: b.free + updatedOrderData.executedQty);
            }
            if (updatedOrderData.symbol.endsWith(b.asset)) {
              return b.copyWith(
                  locked: b.locked - updatedOrderData.cummulativeQuoteQty);
            }
          }
          if (updatedOrderData.side == OrderSides.SELL) {
            if (updatedOrderData.symbol.startsWith(b.asset)) {
              return b.copyWith(
                  locked: b.locked - updatedOrderData.executedQty);
            }
            if (updatedOrderData.symbol.endsWith(b.asset)) {
              return b.copyWith(
                  free: b.free + updatedOrderData.cummulativeQuoteQty);
            }
          }

          return b;
        }).toList();

        return updatedOrderData;
      }

      return o;
    }).first;

    // Update with new OrderData
    orders.removeAt(orders.indexWhere((o) => order.orderId == o.orderId));
    orders.add(order);

    return order;
  }

  bool _shouldFillOrder(OrderData o) {
    final currentPrice = getPriceStrategy();
    switch (o.type) {
      case OrderTypes.LIMIT:
        return (o.side == OrderSides.BUY && currentPrice < o.price) ||
            (o.side == OrderSides.SELL && currentPrice > o.price);
      case OrderTypes.STOP_LOSS_LIMIT:
        return (o.side == OrderSides.BUY && currentPrice >= o.stopPrice!) ||
            (o.side == OrderSides.SELL && currentPrice <= o.stopPrice!);
      default:
        throw UnimplementedError(
            'Missing update order implementation for order of type "${o.type}"');
    }
  }

  OrderCancel cancelOrder(TestWallet wallet, int orderId) {
    final index = orders.indexWhere((o) => o.orderId == orderId);
    orders[index] = orders[index].copyWith(status: OrderStatus.CANCELED);

    final orderCancel = TestUtils.createOrderCancel(orders[index]);

    wallet.balances = wallet.balances.map((b) {
      // Check whether balance has been used in this order and if so update the account wallet
      if (orderCancel.side == OrderSides.BUY) {
        if (orderCancel.symbol.endsWith(b.asset)) {
          final cummulativeQuoteQty = orderCancel.price * orderCancel.origQty;
          return b.copyWith(
              free: b.free + cummulativeQuoteQty,
              locked: b.locked - cummulativeQuoteQty);
        }
      }
      if (orderCancel.side == OrderSides.SELL) {
        if (orderCancel.symbol.startsWith(b.asset)) {
          return b.copyWith(
              free: b.free + orderCancel.origQty,
              locked: b.locked - orderCancel.origQty);
        }
      }

      return b;
    }).toList();

    return orderCancel;
  }
}
