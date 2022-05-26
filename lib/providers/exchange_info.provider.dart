import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/models/exchange_info_networks.dart';
import 'package:bottino_fortino/providers/exchange_info_networks.provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exchangeInfoProvider = Provider<ExchangeInfoProvider?>(
  (ref) => ref.watch(exchangeInfoNetworksProvider).whenOrNull(
        data: (data) => ExchangeInfoProvider(ref, data),
      ),
);

class ExchangeInfoProvider {
  final Ref ref;
  final ExchangeInfoNetworks exchangeInfoNetworks;

  const ExchangeInfoProvider(this.ref, this.exchangeInfoNetworks);

  List<Symbol> getCompatibleSymbolsWithMinimizeLosses({bool isTestNet = true}) {
    // Get enabled symbols sorted alphabetically
    return getNetworkSymbols(isTestNet)
        .where((s) =>
            s.isSpotTradingAllowed &&
            s.orderTypes.any((o) => o == OrderTypes.STOP_LOSS_LIMIT) &&
            s.orderTypes.any((o) => o == OrderTypes.LIMIT))
        .toList()
      ..sort((a, b) => a.symbol.compareTo(b.symbol));
  }

  int getSymbolPrecision(String symbol, {bool isTestNet = true}) {
    final symbolPrecisions = getNetworkSymbols(isTestNet)
        .where((s) => s.symbol == symbol)
        .map((s) => s.quotePrecision);
    // Returns precision default value
    if (symbolPrecisions.isEmpty) return 8;

    return symbolPrecisions.first;
  }

  List<Symbol> getNetworkSymbols(bool isTestNet) {
    if (isTestNet) {
      return exchangeInfoNetworks.testNet.symbols;
    }
    return exchangeInfoNetworks.pubNet.symbols;
  }
}
