part of dashboard_module;

class OrderContainer extends StatelessWidget {
  final Order _order;

  const OrderContainer(this._order, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateTime = _order.map(
      orderData: (o) => o.updateTime,
      orderNew: (o) => o.transactTime,
      orderCancel: (o) => o.transactTime,
    );

    final String formattedDate = DateTimeUtils.toHmsddMMy(dateTime);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () => context.router.push(OrderDetailRoute(order: _order)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OrderStatusIndicator(_order.status),
              const SizedBox(width: 5),
              Text(
                  '${_order.side == OrderSides.BUY ? 'Bought at' : 'Sold at'}: $formattedDate'),
            ],
          ),
        ),
      ),
    );
  }
}
