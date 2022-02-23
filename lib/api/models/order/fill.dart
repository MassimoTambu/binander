part of api;

@JsonSerializable()
class Fill {
  @JsonKey(fromJson: ParseUtils.stringToDouble)
  final double price;
  @JsonKey(fromJson: ParseUtils.stringToDouble)
  final double qty;
  @JsonKey(fromJson: ParseUtils.stringToDouble)
  final double commission;
  final String commissionAsset;
  final int tradeId;

  const Fill(
    this.price,
    this.qty,
    this.commission,
    this.commissionAsset,
    this.tradeId,
  );

  factory Fill.fromJson(Map<String, dynamic> json) => _$FillFromJson(json);

  Map<String, dynamic> toJson() => _$FillToJson(this);
}
