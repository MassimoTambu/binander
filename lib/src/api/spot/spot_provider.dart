part of api;

@riverpod
Spot _spot(_SpotRef ref, ApiConnection apiConnection) => Spot(
      ref.watch(_marketProvider(apiConnection)),
      ref.watch(_tradeProvider(apiConnection)),
      ref.watch(_walletProvider(apiConnection)),
    );

class Spot {
  final Market market;
  final Trade trade;
  final Wallet wallet;

  const Spot(this.market, this.trade, this.wallet);
}
