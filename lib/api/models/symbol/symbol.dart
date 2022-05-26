part of api;

@freezed
class Symbol with _$Symbol {
  const factory Symbol(
    String symbol,
    String status,
    String baseAsset,
    int baseAssetPrecision,
    String quoteAsset,
    int quotePrecision,
    int quoteAssetPrecision,
    List<OrderTypes> orderTypes,
    bool icebergAllowed,
    bool ocoAllowed,
    bool quoteOrderQtyMarketAllowed,
    bool allowTrailingStop,
    bool isSpotTradingAllowed,
    bool isMarginTradingAllowed,
    List<SymbolFilter> filters,
    List<Permissions> permissions,
  ) = _Symbol;

  factory Symbol.fromJson(Map<String, dynamic> json) => _$SymbolFromJson(json);
}
