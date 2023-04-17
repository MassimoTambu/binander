import 'package:binander/src/common_widgets/crypto_info/crypto_info_tile.dart';
import 'package:binander/src/common_widgets/detailed_error_box.dart';
import 'package:binander/src/features/settings/domain/api_connection.dart';
import 'package:binander/src/features/settings/presentation/binance_account_information_provider.dart';
import 'package:binander/src/features/settings/presentation/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crypto_info.g.dart';

@riverpod
bool isTestNet(ref) => throw UnimplementedError();

class CryptoInfo extends ConsumerWidget {
  const CryptoInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final ApiConnection apiConn;

    if (ref.watch(isTestNetProvider)) {
      apiConn = ref.watch(settingsStorageProvider
          .select((p) => p.requireValue.testNetConnection));
    } else {
      apiConn = ref.watch(settingsStorageProvider
          .select((p) => p.requireValue.pubNetConnection));
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
              child: const CryptoInfoTile(),
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
