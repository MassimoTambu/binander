import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bottino_fortino/utils/datetime.utils.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatelessWidget {
  final Order _order;

  const OrderDetailPage(this._order, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderInfos = [
      'Id: ${_order.orderId}',
      'OrigQty: ${_order.origQty}',
      'ExecutedQty: ${_order.executedQty}',
      'Price: ${_order.price}',
      'Symbol: ${_order.symbol}',
      'Side: ${_order.side.name}',
      'Status: ${_order.status.name}',
      'Type: ${_order.type.name}',
      ..._order.map(
        data: (o) => [
          'Time: ${DateTimeUtils.toHmsddMMy(o.time)}',
          'Updated time: ${DateTimeUtils.toHmsddMMy(o.updateTime)}',
        ],
        newLimit: (o) {
          final texts = [
            'Transact time: ${DateTimeUtils.toHmsddMMy(o.transactTime)}'
          ];
          if (o.fills.isNotEmpty) {
            texts.add('Fills:');
            for (final fill in o.fills) {
              texts.addAll([
                '- TradeId: ${fill.tradeId}',
                '  Commission: ${fill.commission}',
                '  CommissionAsset: ${fill.commissionAsset}',
                '  Price: ${fill.price}',
                '  Qty: ${fill.qty}',
              ]);
            }
          }

          return texts;
        },
        cancel: (o) => [
          'Transact time: ${DateTimeUtils.toHmsddMMy(o.transactTime)}',
        ],
      ),
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
          itemBuilder: (context, i) => Text(
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
