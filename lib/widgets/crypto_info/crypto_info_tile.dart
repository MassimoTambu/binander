part of widgets;

final currentAccountBalance =
    Provider<AccountBalance>((ref) => throw UnimplementedError());

class _CryptoInfoTile extends ConsumerWidget {
  const _CryptoInfoTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountBalance = ref.watch(currentAccountBalance);
    return Column(
      children: [
        Text(accountBalance.asset),
        Text('free: ${accountBalance.free}'),
        Text('locked: ${accountBalance.locked}'),
      ],
    );
  }
}
