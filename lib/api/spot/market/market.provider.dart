part of api;

final _marketProvider = Provider<MarketProvider>((ref) {
  return MarketProvider(ref);
});

class MarketProvider {
  final Ref _ref;
  late final ApiUtils apiUtils = _ref.read(_apiUtilsProvider);

  MarketProvider(this._ref);

  Future<ApiResponse<AveragePrice>> getAveragePrice(
      ApiConnection conn, CryptoSymbol symbol) async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        conn.apiKey, headers, API_SECURITY_TYPE.userData);

    final options = Options(headers: headers);

    final query = {'symbol': symbol.toString()};
    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, query, API_SECURITY_TYPE.none);

    try {
      final response = await _ref.read(_dioProvider).get<String>(
          '${conn.url}/api/v3/avgPrice',
          options: options,
          queryParameters: secureQuery);
      return ApiResponse(AveragePrice.fromJson(jsonDecode(response.data!)),
          response.statusCode!);
    } on DioError catch (e) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('getAveragePrice', e));
    }
  }
}
