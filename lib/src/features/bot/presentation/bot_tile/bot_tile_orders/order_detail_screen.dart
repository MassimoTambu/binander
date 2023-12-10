import 'package:binander/src/api/api.dart';
import 'package:binander/src/routing/app_router.dart';
import 'package:binander/src/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderData _order;

  const OrderDetailsScreen(this._order, {super.key});

  @override
  Widget build(BuildContext context) {
    final orderInfos = [
      'Id: ${_order.orderId}',
      'OrigQty: ${_order.origQty}',
      'ExecutedQty: ${_order.executedQty}',
      'CummulativeQuoteQty: ${_order.cummulativeQuoteQty}',
      'Price: ${_order.price}',
      if (_order.stopPrice != null) 'Stop price: ${_order.stopPrice}',
      'CummulativeQuotePrice: ${_order.cummulativeQuotePrice}',
      'Symbol: ${_order.symbol}',
      'Side: ${_order.side.name}',
      'Status: ${_order.status.name}',
      'Type: ${_order.type.name}',
      'Time: ${kDateFormatter.format(_order.time)}',
      'Updated time: ${kDateFormatter.format(_order.updateTime)}',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(AppRoute.settings.name),
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
              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
            ),
            textAlign: TextAlign.center,
          ),
          separatorBuilder: (context, i) => const SizedBox(height: 20),
        ),
      ),
    );
  }
}
