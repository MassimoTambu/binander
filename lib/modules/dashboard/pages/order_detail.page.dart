import 'package:binander/api/api.dart';
import 'package:binander/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:binander/utils/datetime.utils.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderData _order;

  const OrderDetailPage(this._order, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderInfos = [
      'Id: ${_order.orderId}',
      'OrigQty: ${_order.origQty}',
      'ExecutedQty: ${_order.executedQty}',
      'Price: ${_order.price}',
      if (_order.stopPrice != null) 'Stop price: ${_order.stopPrice}',
      'Symbol: ${_order.symbol}',
      'Side: ${_order.side.name}',
      'Status: ${_order.status.name}',
      'Type: ${_order.type.name}',
      'Time: ${DateTimeUtils.toHmsddMMy(_order.time)}',
      'Updated time: ${DateTimeUtils.toHmsddMMy(_order.updateTime)}',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.router.push(const SettingsRoute()),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: ListView.separated(
          padding: const EdgeInsets.all(18),
          itemCount: orderInfos.length,
          itemBuilder: (context, i) => SelectableText(
            orderInfos[i],
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headline6!.fontSize,
            ),
            textAlign: TextAlign.center,
          ),
          separatorBuilder: (context, i) => const SizedBox(height: 20),
        ),
      ),
    );
  }
}
