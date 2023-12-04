part of '../../api.dart';

@riverpod
Market _market(_MarketRef ref, ApiConnection apiConnection) {
  final apiUtils = ref.watch(_apiUtilsProvider);
  return Market(ref, apiConnection, apiUtils);
}

class Market {
  final Ref _ref;
  final ApiConnection _conn;
  final ApiUtils _apiUtils;

  const Market(this._ref, this._conn, this._apiUtils);

  Future<ApiResponse<AveragePrice>> getAveragePrice(CryptoSymbol symbol) async {
    final headers = <String, dynamic>{};

    _apiUtils.addSecurityToHeader(
        _conn.apiKey, headers, API_SECURITY_TYPES.userData);

    final options = Options(headers: headers);

    final query = {'symbol': symbol.toString()};
    final secureQuery = _apiUtils.createQueryWithSecurity(
        _conn.apiSecret, query, API_SECURITY_TYPES.none);

    try {
      final response = await _ref.read(_dioProvider).get<Map<String, dynamic>>(
          '${_conn.url}/api/v3/avgPrice',
          options: options,
          queryParameters: secureQuery);
      return ApiResponse(
          AveragePrice.fromJson(response.data!), response.statusCode!);
    } catch (e) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('getAveragePrice', e));
    }
  }

  Future<ApiResponse<ExchangeInfo>> getExchangeInfo(
      {List<CryptoSymbol> symbols = const []}) async {
    final headers = <String, dynamic>{};

    _apiUtils.addSecurityToHeader(
        _conn.apiKey, headers, API_SECURITY_TYPES.none);

    final options = Options(headers: headers);

    final query = symbols.isEmpty
        ? <String, String>{}
        : {'symbols': '[${symbols.map((s) => '"$s"').join(',')}]'};
    final secureQuery = _apiUtils.createQueryWithSecurity(
        _conn.apiSecret, query, API_SECURITY_TYPES.none);

    try {
      final response = await _ref.read(_dioProvider).get<Map<String, dynamic>>(
          '${_conn.url}/api/v3/exchangeInfo',
          options: options,
          queryParameters: secureQuery);
      return ApiResponse(
          ExchangeInfo.fromJson(response.data!), response.statusCode!);
    } catch (e) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('getExchangeInfo', e));
    }
  }
}
