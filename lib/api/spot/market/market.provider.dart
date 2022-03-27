part of api;

final _marketProvider = Provider<MarketProvider>((ref) {
  return MarketProvider(ref);
});

class MarketProvider {
  final Ref _ref;
  late final ApiUtils apiUtils = _ref.read(_apiUtilsProvider);

  MarketProvider(this._ref);

  Future<ApiResponse<AveragePrice>> getAveragePrice(
      ApiConnection conn, String symbol) async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        conn.apiKey, headers, API_SECURITY_TYPE.userData);

    final options = dio.Options(headers: headers);

    final query = {'symbol': symbol};
    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, query, API_SECURITY_TYPE.none);

    late final dio.Response<String> response;
    try {
      response = await _ref.read(_dioProvider).get(
          '${conn.url}/api/v3/avgPrice',
          options: options,
          queryParameters: secureQuery);
    } on dio.DioError catch (_) {
      return Future.error(_ref
          .read(_apiUtilsProvider)
          .buildApiException('getAveragePrice', response));
    }

    final res = ApiResponse(AveragePrice.fromJson(jsonDecode(response.data!)),
        response.statusCode!);

    return res;
  }
}