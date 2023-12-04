part of '../../api.dart';

@Freezed(unionKey: 'filterType')
class SymbolFilter with _$SymbolFilter {
  @FreezedUnionValue('PRICE_FILTER')
  const factory SymbolFilter.priceFilter(
    SymbolFilterTypes filterType,
    String minPrice,
    String maxPrice,
    String tickSize,
  ) = _SymbolFilterPriceFilter;

  @FreezedUnionValue('PERCENT_PRICE')
  const factory SymbolFilter.percentPrice(
    SymbolFilterTypes filterType,
    String multiplierUp,
    String multiplierDown,
    int avgPriceMins,
  ) = _SymbolFilterPercentPrice;

  @FreezedUnionValue('PERCENT_PRICE_BY_SIDE')
  const factory SymbolFilter.percentPriceBySide(
    SymbolFilterTypes filterType,
    String bidMultiplierUp,
    String bidMultiplierDown,
    String askMultiplierUp,
    String askMultiplierDown,
    int avgPriceMins,
  ) = _SymbolFilterPercentPriceBySide;

  @FreezedUnionValue('LOT_SIZE')
  const factory SymbolFilter.lotSize(
    SymbolFilterTypes filterType,
    String minQty,
    String maxQty,
    String stepSize,
  ) = _SymbolFilterLotSize;

  @FreezedUnionValue('MIN_NOTIONAL')
  const factory SymbolFilter.minNotional(
    SymbolFilterTypes filterType,
    String minNotional,
    bool applyToMarket,
    int avgPriceMins,
  ) = _SymbolFilterMinNotional;

  @FreezedUnionValue('NOTIONAL')
  const factory SymbolFilter.notional(
    SymbolFilterTypes filterType,
    String minNotional,
    String maxNotional,
    bool applyMinToMarket,
    bool applyMaxToMarket,
    int avgPriceMins,
  ) = _SymbolFilterNotional;

  @FreezedUnionValue('ICEBERG_PARTS')
  const factory SymbolFilter.icebergParts(
    SymbolFilterTypes filterType,
    int limit,
  ) = _SymbolFilterIceberParts;

  @FreezedUnionValue('MARKET_LOT_SIZE')
  const factory SymbolFilter.marketLotSize(
    SymbolFilterTypes filterType,
    String minQty,
    String maxQty,
    String stepSize,
  ) = _SymbolFilterMarketLotSize;

  @FreezedUnionValue('MAX_NUM_ORDERS')
  const factory SymbolFilter.maxNumOrders(
    SymbolFilterTypes filterType,
    int maxNumOrders,
  ) = _SymbolFilterMaxNumOrders;

  @FreezedUnionValue('MAX_NUM_ALGO_ORDERS')
  const factory SymbolFilter.maxNumAlgoOrders(
    SymbolFilterTypes filterType,
    int maxNumAlgoOrders,
  ) = _SymbolFilterMaxNumAlgoOrders;

  @FreezedUnionValue('MAX_NUM_ICEBERG_ORDERS')
  const factory SymbolFilter.maxNumIcebergOrders(
    SymbolFilterTypes filterType,
    int maxNumIcebergOrders,
  ) = _SymbolFilterMaxNumIcebergOrders;

  @FreezedUnionValue('MAX_POSITION')
  const factory SymbolFilter.maxPosition(
    SymbolFilterTypes filterType,
    String maxPosition,
  ) = _SymbolFilterMaxPosition;

  @FreezedUnionValue('TRAILING_DELTA')
  const factory SymbolFilter.trailingDelta(
    SymbolFilterTypes filterType,
    int minTrailingAboveDelta,
    int maxTrailingAboveDelta,
    int minTrailingBelowDelta,
    int maxTrailingBelowDelta,
  ) = _SymbolFilterTrailingDelta;

  @FreezedUnionValue('EXCHANGE_MAX_NUM_ORDERS')
  const factory SymbolFilter.exchangeMaxNumOrders(
    SymbolFilterTypes filterType,
    int maxNumOrders,
  ) = _SymbolFilterExchangeMaxNumOrders;

  @FreezedUnionValue('EXCHANGE_MAX_NUM_ALGO_ORDERS')
  const factory SymbolFilter.exchangeMaxNumAlgoOrders(
    SymbolFilterTypes filterType,
    int maxNumAlgoOrders,
  ) = _SymbolFilterExchangeMaxNumAlgoOrders;

  @FreezedUnionValue('EXCHANGE_MAX_NUM_ICEBERG_ORDERS')
  const factory SymbolFilter.exchangeMaxNumIcebergOrders(
    SymbolFilterTypes filterType,
    int maxNumIcebergOrders,
  ) = _SymbolFilterExchangeMaxNumIcebergOrders;

  factory SymbolFilter.fromJson(Map<String, dynamic> json) =>
      _$SymbolFilterFromJson(json);
}
