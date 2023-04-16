part of api;

@freezed
class AccountBalance with _$AccountBalance {
  const factory AccountBalance(
          String asset,
          @JsonKey(fromJson: ParseUtils.stringToDouble) double free,
          @JsonKey(fromJson: ParseUtils.stringToDouble) double locked) =
      _AccountBalance;

  factory AccountBalance.fromJson(Map<String, dynamic> json) =>
      _$AccountBalanceFromJson(json);
}
