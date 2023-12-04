part of '../api.dart';

@freezed
class ExchangeInfo with _$ExchangeInfo {
  const factory ExchangeInfo(
    String timezone,
    int serverTime,
    List<RateLimit> rateLimits,
    List<ExchangeFilter> exchangeFilters,
    List<Symbol> symbols,
  ) = _ExchangeInfo;

  factory ExchangeInfo.fromJson(Map<String, dynamic> json) =>
      _$ExchangeInfoFromJson(json);
}
