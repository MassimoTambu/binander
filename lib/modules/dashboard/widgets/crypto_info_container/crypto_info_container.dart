part of dashboard_module;

class _CryptoInfoContainer extends ConsumerWidget {
  const _CryptoInfoContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExpansionTile(
      title: Text(
        "Funds",
        style: Theme.of(context).textTheme.headline5,
      ),
      initiallyExpanded: true,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            ProviderScope(
              overrides: [isTestNetProvider.overrideWithValue(false)],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _CryptoInfoTitle('Pub Net'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 3,
                    child: const CryptoInfo(),
                  ),
                ],
              ),
            ),
            ProviderScope(
              overrides: [isTestNetProvider.overrideWithValue(true)],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _CryptoInfoTitle('Test Net'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 3,
                    child: const CryptoInfo(),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
