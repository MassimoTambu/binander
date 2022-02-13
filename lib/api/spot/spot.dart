part of api;

final _spotProvider = Provider<Spot>((ref) {
  return Spot(ref);
});

class Spot {
  final Ref _ref;
  late final Market market;
  late final Trade trade;
  late final Wallet wallet;

  Spot(this._ref) {
    market = _ref.watch(_marketProvider);
    trade = _ref.watch(_tradeProvider);
    wallet = _ref.watch(_walletProvider);
  }
}
