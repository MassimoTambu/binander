part of api;

@JsonSerializable()
class AveragePrice {
  final int mins;
  @JsonKey(
      fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
  final double price;

  const AveragePrice(this.mins, this.price);

  factory AveragePrice.fromJson(Map<String, dynamic> json) =>
      _$AveragePriceFromJson(json);

  Map<String, dynamic> toJson() => _$AveragePriceToJson(this);
}
