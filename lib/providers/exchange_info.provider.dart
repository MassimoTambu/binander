import 'package:binander/api/api.dart';
import 'package:binander/models/exchange_info_networks.dart';
import 'package:binander/providers/exchange_info_networks.provider.dart';
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

  List<Symbol> _getNetworkSymbols(bool isTestNet) {
    if (isTestNet) {
      return exchangeInfoNetworks.testNet.symbols;
    }
    return exchangeInfoNetworks.pubNet.symbols;
  }

  List<Symbol> getCompatibleSymbolsWithMinimizeLosses({bool isTestNet = true}) {
    // Get enabled symbols sorted alphabetically
    return _getNetworkSymbols(isTestNet)
        .where((s) =>
            s.isSpotTradingAllowed &&
            s.orderTypes.any((o) => o == OrderTypes.STOP_LOSS_LIMIT) &&
            s.orderTypes.any((o) => o == OrderTypes.LIMIT))
        .toList()
      ..sort((a, b) => a.symbol.compareTo(b.symbol));
  }

  int getOrderPrecision(String symbol, {bool isTestNet = true}) {
    final priceFilters = _getNetworkSymbols(isTestNet)
        .where((s) => s.symbol == symbol)
        .map((s) => s.filters
            .firstWhere((f) => f.filterType == SymbolFilterTypes.PRICE_FILTER));
    // Returns precision default value
    if (priceFilters.isEmpty) return 2;

    final minPrice = priceFilters.first.maybeMap(
        priceFilter: (p) => double.tryParse(p.minPrice), orElse: () => null);

    if (minPrice == null) return 2;

    return _getDecimalPlaces(minPrice);
  }

  int getQuantityPrecision(String symbol, {bool isTestNet = true}) {
    final priceFilters = _getNetworkSymbols(isTestNet)
        .where((s) => s.symbol == symbol)
        .map((s) => s.filters
            .firstWhere((f) => f.filterType == SymbolFilterTypes.LOT_SIZE));
    // Returns precision default value
    if (priceFilters.isEmpty) return 0;

    final minQty = priceFilters.first.maybeMap(
        lotSize: (l) => double.tryParse(l.minQty), orElse: () => null);

    if (minQty == null) return 0;

    return _getDecimalPlaces(minQty);
  }

  int _getDecimalPlaces(double value) {
    int tenMultiple = 10;
    int count = 0;
    double manipluatedNum = value;

    while (manipluatedNum.ceil() != manipluatedNum.floor()) {
      manipluatedNum = value * tenMultiple;
      count += 1;
      tenMultiple *= 10;
    }

    return count;
  }
}
