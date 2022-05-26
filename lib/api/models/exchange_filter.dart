part of api;

@freezed
class ExchangeFilter with _$ExchangeFilter {
  const factory ExchangeFilter.maxNumOrders(
    ExchangeFilterTypes filterType,
    int maxNumOrders,
  ) = _ExchangeFilterMaxNumOrders;

  const factory ExchangeFilter.maxNumAlgoOrders(
    ExchangeFilterTypes filterType,
    int maxNumAlgoOrders,
  ) = _ExchangeFilterMaxNumAlgoOrders;

  factory ExchangeFilter.fromJson(Map<String, dynamic> json) =>
      _$ExchangeFilterFromJson(json);
}
