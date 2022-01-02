part of api;

final _spotProvider = Provider<Spot>((ref) {
  return Spot(ref);
});

class Spot {
  final Ref ref;
  late Trade trade;

  Spot(this.ref) {
    trade = ref.watch(_tradeProvider);
  }
}
