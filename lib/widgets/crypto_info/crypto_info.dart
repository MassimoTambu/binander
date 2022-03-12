part of widgets;

class CryptoInfo extends ConsumerWidget {
  final bool testNet;

  const CryptoInfo(this.testNet, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final ApiConnection apiConn;

    if (testNet) {
      apiConn = ref.watch(settingsProvider.select((p) => p.testNetConnection));
    } else {
      apiConn = ref.watch(settingsProvider.select((p) => p.pubNetConnection));
    }

    final res = ref.watch(binanceAccountInformationProvider(apiConn));
    return res.when(
      data: (data) {
        return ListView.builder(itemBuilder: ((context, index) {
          return ProviderScope(
            overrides: [
              currentAccountBalance.overrideWithValue(data.body.balances[index])
            ],
            child: const _CryptoInfoTile(),
          );
        }));
      },
      error: (error, stackTrace) {
        return DetailedErrorBox(error, stackTrace);
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}
