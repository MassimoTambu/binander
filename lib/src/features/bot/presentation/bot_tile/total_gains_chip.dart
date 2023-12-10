import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/bot/domain/run_orders.dart';
import 'package:flutter/material.dart';

class TotalGainsChip extends StatelessWidget {
  final Iterable<RunOrders> _runOrders;

  const TotalGainsChip(this._runOrders, {super.key});

  @override
  Widget build(BuildContext context) {
    if (_runOrders.isEmpty) {
      return Container();
    }

    final totalGains = _runOrders
        .where((ro) => ro.sellOrder?.status == OrderStatus.FILLED)
        .map((op) => op.gains)
        .fold<double>(0, (acc, g) => acc + g);

    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          switch (totalGains) {
            < -30 =>
              const Icon(Icons.keyboard_double_arrow_down, color: Colors.red),
            < 0 =>
              const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.red),
            >= 500 =>
              const Icon(Icons.dark_mode, color: Colors.amber, size: 20),
            >= 60 => const Icon(Icons.rocket_launch_rounded,
                color: Colors.yellow, size: 20),
            >= 30 => const Icon(Icons.keyboard_double_arrow_up_rounded,
                color: Colors.green),
            > 0 =>
              const Icon(Icons.keyboard_arrow_up_rounded, color: Colors.green),
            _ => const Icon(Icons.drag_handle, color: Colors.yellow),
          },
          const SizedBox(width: 5),
          Text(
            '${totalGains.abs()} ${_runOrders.isEmpty ? '-' : _runOrders.first.buyOrder!.symbol}',
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
