import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/settings/presentation/settings_provider.dart';
import 'package:binander/src/models/exchange_info_networks.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exchange_info_networks_provider.g.dart';

@riverpod
Future<ExchangeInfoNetworks> exchangeInfoNetworks(
    ExchangeInfoNetworksRef ref) async {
  final pubNetConn =
      ref.watch(settingsStorageProvider).requireValue.pubNetConnection;
  final pubNet =
      ref.watch(binanceApiProvider(pubNetConn)).spot.market.getExchangeInfo();
  final testNetConn =
      ref.watch(settingsStorageProvider).requireValue.testNetConnection;
  final testNet =
      ref.watch(binanceApiProvider(testNetConn)).spot.market.getExchangeInfo();

  final res = await Future.wait([pubNet, testNet]);

  return ExchangeInfoNetworks(pubNet: res[0].body, testNet: res[1].body);
}
