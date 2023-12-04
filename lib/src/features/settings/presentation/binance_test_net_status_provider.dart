import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/settings/presentation/settings_storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'binance_test_net_status_provider.g.dart';

@riverpod
Future<ApiResponse<AccountInformation>> binanceTestNetStatus(
    BinanceTestNetStatusRef ref) async {
  final testConn =
      ref.watch(settingsStorageProvider.select((p) => p.testNetConnection));
  return await ref
      .watch(binanceApiProvider(testConn))
      .spot
      .trade
      .getAccountInformation();
}
