part of api;

@Freezed(makeCollectionsUnmodifiable: false)
class AccountInformation with _$AccountInformation {
  const factory AccountInformation(
    int makerCommission,
    int takerCommission,
    int buyerCommission,
    int sellerCommission,
    bool canTrade,
    bool canWithdraw,
    bool canDeposit,
    @JsonKey(fromJson: ParseUtils.unixToDateTime, toJson: ParseUtils.dateTimeToUnix)
        DateTime updateTime,
    String accountType,
    List<AccountBalance> balances,
    List<String> permissions,
  ) = _AccountInformation;

  factory AccountInformation.fromJson(Map<String, dynamic> json) =>
      _$AccountInformationFromJson(json);
}
