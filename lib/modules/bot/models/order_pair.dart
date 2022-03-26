part of bot;

@freezed
class OrderPair with _$OrderPair {
  const factory OrderPair({required Order buyOrder, required Order sellOrder}) =
      _OrderPair;

  factory OrderPair.fromJson(Map<String, dynamic> json) =>
      _$OrderPairFromJson(json);
}
