import 'package:bottino_fortino/modules/settings/models/api_connection.dart';
import 'package:bottino_fortino/modules/settings/providers/settings.provider.dart';
import 'package:bottino_fortino/providers/binance_account_information.provider.dart';
import 'package:bottino_fortino/widgets/crypto_info/crypto_info_tile.dart';
import 'package:bottino_fortino/widgets/detailed_error_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
