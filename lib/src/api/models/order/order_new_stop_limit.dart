part of '../../api.dart';

@freezed
class OrderNewStopLimit with _$OrderNewStopLimit {
  const factory OrderNewStopLimit.newStopLimit(
    String symbol,
    int orderId,
    int orderListId,
    String clientOrderId,
    @JsonKey(
        fromJson: ParseUtils.unixToDateTime, toJson: ParseUtils.dateTimeToUnix)
    DateTime transactTime,
  ) = _OrderNewStopLimit;

  factory OrderNewStopLimit.fromJson(Map<String, dynamic> json) =>
      _$OrderNewStopLimitFromJson(json);
}
