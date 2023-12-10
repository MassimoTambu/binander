import 'package:binander/src/features/bot/domain/run_orders.dart';
import 'package:binander/src/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class BotTileRunOrdersExecutionDate extends StatelessWidget {
  const BotTileRunOrdersExecutionDate({required this.runOrders, super.key});

  final RunOrders runOrders;

  @override
  Widget build(BuildContext context) {
    final fromTime = switch (runOrders.buyOrder) {
      == null => null,
      _ => kDateTimeFormatter.format(runOrders.buyOrder!.time),
    };
    final toTime = switch (runOrders.sellOrder) {
      == null => null,
      _ => kDateTimeFormatter.format(runOrders.sellOrder!.time),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fromTime != null) Text("From $fromTime"),
        if (toTime != null) Text("To $toTime"),
      ],
    );
  }
}
