import 'package:binander/api/api.dart';
import 'package:binander/models/exchange_info_networks.dart';
import 'package:binander/modules/settings/providers/settings.provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exchangeInfoNetworksProvider =
    FutureProvider<ExchangeInfoNetworks>((ref) async {
  final pubNet = ref
      .watch(apiProvider)
      .spot
      .market
      .getExchangeInfo(ref.watch(settingsProvider).pubNetConnection);
  final testNet = ref
      .watch(apiProvider)
      .spot
      .market
      .getExchangeInfo(ref.watch(settingsProvider).testNetConnection);

  final res = await Future.wait([pubNet, testNet]);

  return ExchangeInfoNetworks(pubNet: res[0].body, testNet: res[1].body);
});
