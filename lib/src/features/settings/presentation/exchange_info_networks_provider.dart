import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/settings/domain/exchange_info_networks.dart';
import 'package:binander/src/features/settings/presentation/settings_storage_provider.dart';

part 'exchange_info_networks_provider.g.dart';

@riverpod
Future<ExchangeInfoNetworks> exchangeInfoNetworks(
    ExchangeInfoNetworksRef ref) async {
  final pubNetConn = ref.watch(settingsStorageProvider).pubNetConnection;
  final testNetConn = ref.watch(settingsStorageProvider).testNetConnection;
  final exchangeInfos = (
    ref.watch(binanceApiProvider(pubNetConn)).spot.market.getExchangeInfo(),
    ref.watch(binanceApiProvider(testNetConn)).spot.market.getExchangeInfo()
  );

  final (pubNet, testNet) = await exchangeInfos.wait;

  return ExchangeInfoNetworks(pubNet: pubNet.body, testNet: testNet.body);
}
