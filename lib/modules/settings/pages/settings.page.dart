part of settings_module;

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  void _navigateToApiSettingsPage(BuildContext context) {
    context.router.push(BinanceApiSettingsRoute());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BinanceStatusIndicator<ApiKeyPermission>(
                    title: 'Public Network',
                    futureProvider: binancePubNetStatusProvider,
                    validate: (response) {
                      final perm = response.body;
                      return perm.enableSpotAndMarginTrading &&
                          perm.enableReading &&
                          perm.tradingAuthorityExpirationTime != null &&
                          perm.tradingAuthorityExpirationTime!
                              .isAfter(DateTime.now());
                    },
                  ),
                  const SizedBox(width: 30),
                  BinanceStatusIndicator<AccountInformation>(
                    title: 'Test Network',
                    futureProvider: binanceTestNetStatusProvider,
                    validate: (response) => response.body.canTrade,
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text('Binance Api'),
            subtitle: const Text('Change Binance Api settings'),
            onTap: () => _navigateToApiSettingsPage(context),
          ),
          SwitchListTile(
            value: ref.watch(settingsProvider).themeMode == ThemeMode.dark,
            title: const Text('Dark theme'),
            subtitle: const Text('Enable dark theme'),
            onChanged: (value) {
              ref
                  .read(settingsProvider.notifier)
                  .updateThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
          ),
        ],
      ),
    );
  }
}
