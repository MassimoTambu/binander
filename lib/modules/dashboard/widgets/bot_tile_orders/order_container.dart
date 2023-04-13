import 'package:binander/api/api.dart';
import 'package:binander/modules/dashboard/widgets/bot_tile_orders/order_status_indicator.dart';
import 'package:binander/router/app_router.dart';
import 'package:binander/utils/datetime.utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderContainer extends StatelessWidget {
  final OrderData _order;

  const OrderContainer(this._order, {Key? key}) : super(key: key);

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
    final String formattedDate = DateTimeUtils.toHmsddMMy(_order.updateTime);
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
              Text('$textPhrase: $formattedDate'),
            ],
          ),
        ),
      ),
    );
  }
}
