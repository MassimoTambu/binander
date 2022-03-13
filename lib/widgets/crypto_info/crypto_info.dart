part of widgets;

final isTestNetProvider = Provider<bool>((ref) => throw UnimplementedError());

class CryptoInfo extends ConsumerWidget {
  const CryptoInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final ApiConnection apiConn;

    if (ref.watch(isTestNetProvider)) {
      apiConn = ref.watch(settingsProvider.select((p) => p.testNetConnection));
    } else {
      apiConn = ref.watch(settingsProvider.select((p) => p.pubNetConnection));
    }

    final res = ref.watch(binanceAccountInformationProvider(apiConn));
    return res.when(
      data: (data) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: data.body.balances.length,
          itemBuilder: ((context, index) {
            return ProviderScope(
              overrides: [
                currentAccountBalance
                    .overrideWithValue(data.body.balances[index])
              ],
              child: const _CryptoInfoTile(),
            );
          }),
        );
      },
      error: (error, stackTrace) {
        return DetailedErrorBox(error, stackTrace);
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
