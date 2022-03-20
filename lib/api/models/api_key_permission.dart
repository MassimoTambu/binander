part of api;

@JsonSerializable()
class ApiKeyPermission {
  final bool ipRestrict;
  @JsonKey(
      fromJson: ParseUtils.unixToDateTime, toJson: ParseUtils.dateTimeToUnix)
  final DateTime createTime;
  final bool
      enableWithdrawals; // This option allows you to withdraw via API. You must apply the IP Access Restriction filter in order to enable withdrawals
  final bool
      enableInternalTransfer; // This option authorizes this key to transfer funds between your master account and your sub account instantly
  final bool
      permitsUniversalTransfer; // Authorizes this key to be used for a dedicated universal transfer API to transfer multiple supported currencies. Each business's own transfer API rights are not affected by this authorization
  final bool
      enableVanillaOptions; //  Authorizes this key to Vanilla options trading
  final bool enableReading;
  final bool
      enableFutures; //  API Key created before your futures account opened does not support futures API service
  final bool
      enableMargin; //  This option can be adjusted after the Cross Margin account transfer is completed
  final bool enableSpotAndMarginTrading; // Spot and margin trading
  @JsonKey(
      fromJson: ParseUtils.unixToDateTime, toJson: ParseUtils.dateTimeToUnix)
  final DateTime tradingAuthorityExpirationTime;

  ApiKeyPermission(
      this.ipRestrict,
      this.createTime,
      this.enableWithdrawals,
      this.enableInternalTransfer,
      this.permitsUniversalTransfer,
      this.enableVanillaOptions,
      this.enableReading,
      this.enableFutures,
      this.enableMargin,
      this.enableSpotAndMarginTrading,
      this.tradingAuthorityExpirationTime); // Expiration time for spot and margin trading permission

  factory ApiKeyPermission.fromJson(Map<String, dynamic> json) =>
      _$ApiKeyPermissionFromJson(json);

  Map<String, dynamic> toJson() => _$ApiKeyPermissionToJson(this);
}
