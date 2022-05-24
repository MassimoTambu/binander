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

  Iterable<Symbol> getCompatibleSymbolsWithMinimizeLosses(
      {bool isTestNet = true}) {
    late final List<Symbol> symbols;
    if (isTestNet) {
      symbols = exchangeInfoNetworks.testNet.symbols;
    } else {
      symbols = exchangeInfoNetworks.pubNet.symbols;
    }

    // Get enabled orders for
    return symbols.where((s) =>
        s.isSpotTradingAllowed &&
        s.orderTypes.any((o) => o == OrderTypes.STOP_LOSS_LIMIT) &&
        s.orderTypes.any((o) => o == OrderTypes.LIMIT));
  }
}
