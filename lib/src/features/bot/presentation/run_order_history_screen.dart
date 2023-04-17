import 'package:binander/src/features/bot/domain/run_orders.dart';
import 'package:binander/src/features/bot/presentation/bot_tile_orders/order_container.dart';
import 'package:binander/src/utils/group_by_iterables.dart';
import 'package:flutter/material.dart';

class RunOrderHistoryScreen extends StatelessWidget {
  final RunOrders _runOrders;

  const RunOrderHistoryScreen(this._runOrders, {super.key});

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
