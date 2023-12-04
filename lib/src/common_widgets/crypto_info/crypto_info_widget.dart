import 'package:binander/src/common_widgets/async_value_widget.dart';
import 'package:binander/src/common_widgets/crypto_info/crypto_info_tile_widget.dart';
import 'package:binander/src/features/settings/domain/api_connection.dart';
import 'package:binander/src/features/settings/presentation/binance_account_information_provider.dart';
import 'package:binander/src/features/settings/presentation/settings_storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crypto_info_widget.g.dart';

@riverpod
bool isTestNet(ref) => throw UnimplementedError();

class CryptoInfoWidget extends ConsumerWidget {
  const CryptoInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final ApiConnection apiConn;

    if (ref.watch(isTestNetProvider)) {
      apiConn =
          ref.watch(settingsStorageProvider.select((p) => p.testNetConnection));
    } else {
      apiConn =
          ref.watch(settingsStorageProvider.select((p) => p.pubNetConnection));
    }

    final accountInformation =
        ref.watch(binanceAccountInformationProvider(apiConn));
    return AsyncValueWidget(
      value: accountInformation,
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
              child: const CryptoInfoTileWidget(),
            );
          }),
        );
      },
    );
  }
}
