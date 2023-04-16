part of api;

@freezed
class Fill with _$Fill {
  const factory Fill(
    @JsonKey(fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
        double price,
    @JsonKey(fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
        double qty,
    @JsonKey(fromJson: ParseUtils.stringToDouble, toJson: ParseUtils.doubleToString)
        double commission,
    String commissionAsset,
    int tradeId,
  ) = _Fill;

  factory Fill.fromJson(Map<String, dynamic> json) => _$FillFromJson(json);
}
