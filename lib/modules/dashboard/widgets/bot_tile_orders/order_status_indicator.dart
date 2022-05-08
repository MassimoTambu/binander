import 'package:bottino_fortino/api/api.dart';
import 'package:flutter/material.dart';

class OrderStatusIndicator extends StatelessWidget {
  final IconData _icon;
  final Color _color;

  const OrderStatusIndicator(OrderStatus status, {Key? key})
      : _icon = status == OrderStatus.NEW ||
                status == OrderStatus.PARTIALLY_FILLED ||
                status == OrderStatus.PENDING_CANCEL
            ? Icons.send
            : status == OrderStatus.FILLED
                ? Icons.check
                : status == OrderStatus.CANCELED
                    ? Icons.delete
                    : Icons.close,
        _color = status == OrderStatus.NEW ||
                status == OrderStatus.PARTIALLY_FILLED ||
                status == OrderStatus.PENDING_CANCEL
            ? Colors.yellow
            : status == OrderStatus.FILLED
                ? Colors.green
                : status == OrderStatus.CANCELED
                    ? Colors.grey
                    : Colors.black,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(_icon, color: _color);
  }
}
