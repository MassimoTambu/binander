import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/bot/presentation/bot_tile/bot_tile_orders/order_status_indicator.dart';
import 'package:binander/src/routing/app_router.dart';
import 'package:binander/src/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderContainer extends StatelessWidget {
  final OrderData _order;

  const OrderContainer(this._order, {super.key});

  String writeTextPhrase() {
    if (_order.side == OrderSides.BUY && _order.status == OrderStatus.FILLED) {
      return 'Bought at';
    }

    if (_order.side == OrderSides.SELL && _order.status == OrderStatus.FILLED) {
      return 'Sold at';
    }

    return 'Filled at';
  }

  @override
  Widget build(BuildContext context) {
    final textPhrase = writeTextPhrase();

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () =>
            context.pushNamed(AppRoute.orderDetails.name, extra: _order),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OrderStatusIndicator(_order.status),
              const SizedBox(width: 5),
              switch (_order.status) {
                OrderStatus.FILLED =>
                  Text('$textPhrase: ${_order.cummulativeQuotePrice}'),
                _ => Text(
                    '$textPhrase: ${kDateTimeNoSecondsFormatter.format(_order.time)}'),
              },
            ],
          ),
        ),
      ),
    );
  }
}
