part of bot;

@JsonSerializable()
class OrderPair {
  final Order buyOrder;
  final Order sellOrder;

  const OrderPair({required this.buyOrder, required this.sellOrder});

  factory OrderPair.fromJson(Map<String, dynamic> json) =>
      _$OrderPairFromJson(json);

  Map<String, dynamic> toJson() => _$OrderPairToJson(this);
}
