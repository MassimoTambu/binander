part of 'api.dart';

@riverpod
BinanceApi binanceApi(BinanceApiRef ref, ApiConnection apiConnection) {
  final spot = ref.watch(_spotProvider(apiConnection));

  return BinanceApi(spot);
}

class BinanceApi {
  final Spot spot;

  const BinanceApi(this.spot);
}
