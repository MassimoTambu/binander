part of api;

@JsonSerializable()
class AccountInformation {
  final int makerCommission;
  final int takerCommission;
  final int buyerCommission;
  final int sellerCommission;
  final bool canTrade;
  final bool canWithdraw;
  final bool canDeposit;
  @JsonKey(
      fromJson: ParseUtils.unixToDateTime, toJson: ParseUtils.dateTimeToUnix)
  final DateTime updateTime;
  final String accountType;
  final List<AccountBalance> balances;
  final List<String> permissions;

  const AccountInformation(
    this.makerCommission,
    this.takerCommission,
    this.buyerCommission,
    this.sellerCommission,
    this.canTrade,
    this.canWithdraw,
    this.canDeposit,
    this.updateTime,
    this.accountType,
    this.balances,
    this.permissions,
  );

  factory AccountInformation.fromJson(Map<String, dynamic> json) =>
      _$AccountInformationFromJson(json);

  Map<String, dynamic> toJson() => _$AccountInformationToJson(this);
}

@JsonSerializable()
class AccountBalance {
  final String asset;
  @JsonKey(fromJson: ParseUtils.stringToDouble)
  final double free;
  @JsonKey(fromJson: ParseUtils.stringToDouble)
  final double locked;

  const AccountBalance(this.asset, this.free, this.locked);

  factory AccountBalance.fromJson(Map<String, dynamic> json) =>
      _$AccountBalanceFromJson(json);

  Map<String, dynamic> toJson() => _$AccountBalanceToJson(this);
}
