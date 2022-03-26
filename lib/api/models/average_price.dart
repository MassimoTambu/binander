part of api;

@freezed
class AveragePrice with _$AveragePrice {
  const factory AveragePrice(
      int mins,
      @JsonKey(fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
          double price) = _AveragePrice;

  factory AveragePrice.fromJson(Map<String, dynamic> json) =>
      _$AveragePriceFromJson(json);
}
