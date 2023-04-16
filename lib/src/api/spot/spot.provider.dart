part of api;

final _spotProvider = Provider<SpotProvider>((ref) {
  return SpotProvider(ref);
});

class SpotProvider {
  final Ref _ref;
  late final MarketProvider market;
  late final TradeProvider trade;
  late final WalletProvider wallet;

  SpotProvider(this._ref) {
    market = _ref.watch(_marketProvider);
    trade = _ref.watch(_tradeProvider);
    wallet = _ref.watch(_walletProvider);
  }
}
