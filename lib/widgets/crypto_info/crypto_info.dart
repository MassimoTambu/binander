part of widgets;

final isTestNet = Provider<bool>((ref) => throw UnimplementedError());

class CryptoInfo extends ConsumerWidget {
  const CryptoInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final ApiConnection apiConn;

    if (ref.watch(isTestNet)) {
      apiConn = ref.watch(settingsProvider.select((p) => p.testNetConnection));
    } else {
      apiConn = ref.watch(settingsProvider.select((p) => p.pubNetConnection));
    }

    final res = ref.watch(binanceAccountInformationProvider(apiConn));
    return res.when(
      data: (data) {
        return SizedBox(
          height: 200,
          child: ListView.builder(
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
          ),
        );
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
