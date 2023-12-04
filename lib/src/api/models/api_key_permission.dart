part of '../api.dart';

@freezed
class ApiKeyPermission with _$ApiKeyPermission {
  const factory ApiKeyPermission(
    bool ipRestrict,
    @JsonKey(
        fromJson: ParseUtils.unixToDateTime, toJson: ParseUtils.dateTimeToUnix)
    DateTime createTime,

    /// This option allows you to withdraw via API. You must apply the IP Access Restriction filter in order to enable withdrawals
    bool enableWithdrawals,

    /// This option authorizes this key to transfer funds between your master account and your sub account instantly
    bool enableInternalTransfer,

    /// Authorizes this key to be used for a dedicated universal transfer API to transfer multiple supported currencies. Each business's own transfer API rights are not affected by this authorization
    bool permitsUniversalTransfer,

    ///  Authorizes this key to Vanilla options trading
    bool enableVanillaOptions,
    bool enableReading,

    ///  API Key created before your futures account opened does not support futures API service
    bool enableFutures,

    ///  This option can be adjusted after the Cross Margin account transfer is completed
    bool enableMargin,

    /// Spot and margin trading
    bool enableSpotAndMarginTrading,

    /// Expiration time for spot and margin trading permission
    @JsonKey(
        required: false,
        fromJson: ParseUtils.nullUnixToDateTime,
        toJson: ParseUtils.nullDateTimeToUnix)
    DateTime? tradingAuthorityExpirationTime,
  ) = _ApiKeyPermission;

  factory ApiKeyPermission.fromJson(Map<String, dynamic> json) =>
      _$ApiKeyPermissionFromJson(json);
}
