import 'package:binander/src/api/api.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentAccountBalance =
    Provider<AccountBalance>((ref) => throw UnimplementedError());

class CryptoInfoTileWidget extends ConsumerWidget {
  const CryptoInfoTileWidget({super.key});

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
                Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 20),
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
