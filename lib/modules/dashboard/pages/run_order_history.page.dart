import 'package:bottino_fortino/modules/bot/models/run_orders.dart';
import 'package:bottino_fortino/utils/extensions/iterable.extension.dart';
import 'package:flutter/material.dart';

import '../widgets/bot_tile_orders/order_container.dart';

class RunOrderHistoryPage extends StatelessWidget {
  final RunOrders _runOrders;

  const RunOrderHistoryPage(this._runOrders, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupedOrders =
        _runOrders.orders.groupBy((o) => o.orderId).values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Run order history'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemBuilder: (context, index) {
          final orders = groupedOrders[index]
            ..sort(((a, b) => a.updateTime.compareTo(b.updateTime)));
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...orders.map((o) => OrderContainer(o)),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16);
        },
        itemCount: groupedOrders.length,
      ),
    );
  }
}
