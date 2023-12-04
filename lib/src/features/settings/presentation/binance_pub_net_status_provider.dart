import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/settings/presentation/settings_storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'binance_pub_net_status_provider.g.dart';

@riverpod
Future<ApiResponse<ApiKeyPermission>> binancePubNetStatus(
    BinancePubNetStatusRef ref) async {
  final pubConn =
      ref.watch(settingsStorageProvider.select((p) => p.pubNetConnection));
  return await ref
      .read(binanceApiProvider(pubConn))
      .spot
      .wallet
      .getPubNetApiKeyPermission();
}
