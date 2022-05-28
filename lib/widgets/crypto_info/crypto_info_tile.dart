import 'package:binander/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentAccountBalance =
    Provider<AccountBalance>((ref) => throw UnimplementedError());

class CryptoInfoTile extends ConsumerWidget {
  const CryptoInfoTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountBalance = ref.watch(currentAccountBalance);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            accountBalance.asset,
            style:
                Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 20),
          ),
          SizedBox(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'free: ${accountBalance.free}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('locked: ${accountBalance.locked}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
