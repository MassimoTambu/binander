import 'package:binander/src/api/api.dart';
import 'package:binander/src/common_widgets/binance_status.dart';
import 'package:binander/src/features/settings/presentation/binance_pub_net_status_provider.dart';
import 'package:binander/src/features/settings/presentation/binance_test_net_status_provider.dart';
import 'package:binander/src/features/settings/presentation/settings_provider.dart';
import 'package:binander/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _navigateToApiSettingsPage(BuildContext context) {
    context.pushNamed(AppRoute.binanceApiSettings.name);
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
            value: ref.watch(settingsStorageProvider).requireValue.themeMode ==
                ThemeMode.dark,
            title: const Text('Dark theme'),
            subtitle: const Text('Enable dark theme'),
            onChanged: (value) {
              ref
                  .read(settingsStorageProvider.notifier)
                  .updateThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
          ),
        ],
      ),
    );
  }
}
