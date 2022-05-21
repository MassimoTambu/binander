import 'package:bottino_fortino/modules/bot/models/run_orders.dart';
import 'package:flutter/material.dart';

import '../widgets/bot_tile_orders/order_container.dart';

class RunOrderHistoryPage extends StatelessWidget {
  final RunOrders _runOrders;

  const RunOrderHistoryPage(this._runOrders, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Run order history'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OrderContainer(_runOrders.orders[index]),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return const Center(
            child: Icon(Icons.more_vert),
          );
        },
        itemCount: _runOrders.orders.length,
      ),
    );
  }
}
