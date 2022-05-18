import 'package:bottino_fortino/modules/bot/models/run_orders.dart';
import 'package:flutter/material.dart';

class TotalGainsChip extends StatelessWidget {
  final Iterable<RunOrders> _orderPairs;

  const TotalGainsChip(this._orderPairs, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_orderPairs.isEmpty) {
      return Container();
    }

    final totalGains =
        _orderPairs.map((op) => op.gains).reduce((acc, g) => acc + g);

    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          totalGains.isNegative && totalGains <= -30
              ? const Icon(Icons.keyboard_double_arrow_down, color: Colors.red)
              : totalGains.isNegative
                  ? const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Colors.red)
                  : totalGains >= 500
                      ? const Icon(Icons.dark_mode,
                          color: Colors.amber, size: 20)
                      : totalGains >= 60
                          ? const Icon(Icons.rocket_launch_rounded,
                              color: Colors.yellow, size: 20)
                          : totalGains >= 30
                              ? const Icon(
                                  Icons.keyboard_double_arrow_up_rounded,
                                  color: Colors.green)
                              : const Icon(Icons.keyboard_arrow_up_rounded,
                                  color: Colors.green),
          const SizedBox(width: 5),
          Text(
            '${totalGains.abs()} ${_orderPairs.isEmpty ? '-' : _orderPairs.first.buyOrder.symbol}',
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
