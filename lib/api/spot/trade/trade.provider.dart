part of api;

final _tradeProvider = Provider<TradeProvider>((ref) {
  return TradeProvider(ref);
});

class TradeProvider {
  final Ref _ref;
  late final ApiUtils apiUtils = _ref.read(_apiUtilsProvider);

  TradeProvider(this._ref);

  Future<ApiResponse<List<Order>>> getAllOrders(
      ApiConnection conn, String symbol) async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        conn.apiKey, headers, API_SECURITY_TYPE.userData);

    final options = Options(headers: headers);

    final query = {'symbol': symbol};
    // 'symbol=$symbol&timestamp=$timestamp&signature=';
    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, query, API_SECURITY_TYPE.userData);

    late final Response<String> response;
    try {
      response = await _ref.read(dioProvider).get(
          '${conn.url}/api/v3/allOrders',
          options: options,
          queryParameters: secureQuery);
    } on DioError catch (_) {
      return Future.error(_ref
          .read(_apiUtilsProvider)
          .buildApiException('getAllorders', response));
    }

    final rawOrders = jsonDecode(response.data!) as List<dynamic>;

    final res = ApiResponse(
        rawOrders.map((o) => Order.fromJson(o)).toList(), response.statusCode!);

    return res;
  }

  Future<ApiResponse<Order>> getQueryOrder(
      ApiConnection conn, String symbol, int orderId) async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        conn.apiKey, headers, API_SECURITY_TYPE.userData);

    final options = Options(headers: headers);

    final query = {'symbol': symbol, 'orderId': orderId.toString()};
    // 'symbol=$symbol&timestamp=$timestamp&signature=';
    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, query, API_SECURITY_TYPE.userData);

    late final Response<String> response;
    try {
      response = await _ref.read(dioProvider).get('${conn.url}/api/v3/order',
          options: options, queryParameters: secureQuery);
    } on DioError catch (_) {
      return Future.error(_ref
          .read(_apiUtilsProvider)
          .buildApiException('getQueryOrder', response));
    }

    final res = ApiResponse(
        Order.fromJson(jsonDecode(response.data!)), response.statusCode!);

    return res;
  }

  Future<ApiResponse<OrderNew>> newOrder(
    ApiConnection conn,
    String symbol,
    OrderSides side,
    OrderTypes type,
    double quantity,
    double price, {
    TimeInForce timeInForce = TimeInForce.GTC,
  }) async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        conn.apiKey, headers, API_SECURITY_TYPE.userData);

    final options = Options(headers: headers);

    final query = {
      'symbol': symbol,
      'side': side.name,
      'type': type.name,
      'quantity': quantity.toString(),
      'price': price.toString(),
      'timeInForce': timeInForce.name,
    };
    // 'symbol=$symbol&timestamp=$timestamp&signature=';
    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, query, API_SECURITY_TYPE.userData);

    late final Response<String> response;
    try {
      response = await _ref.read(dioProvider).post('${conn.url}/api/v3/order',
          options: options, queryParameters: secureQuery);
    } on DioError catch (_) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('newOrder', response));
    }

    final res = ApiResponse(
        OrderNew.fromJson(jsonDecode(response.data!)), response.statusCode!);

    return res;
  }

  Future<ApiResponse<OrderCancel>> cancelOrder(
    ApiConnection conn,
    String symbol,
    int orderId,
  ) async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        conn.apiKey, headers, API_SECURITY_TYPE.userData);

    final options = Options(headers: headers);

    final query = {
      'symbol': symbol,
      'orderId': orderId.toString(),
    };
    // 'symbol=$symbol&timestamp=$timestamp&signature=';
    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, query, API_SECURITY_TYPE.userData);

    late final Response<String> response;
    try {
      response = await _ref.read(dioProvider).delete('${conn.url}/api/v3/order',
          options: options, queryParameters: secureQuery);
    } on DioError catch (_) {
      return Future.error(_ref
          .read(_apiUtilsProvider)
          .buildApiException('cancelOrder', response));
    }

    final res = ApiResponse(
        OrderCancel.fromJson(jsonDecode(response.data!)), response.statusCode!);

    return res;
  }

  Future<ApiResponse<AccountInformation>> getAccountInformation(
      ApiConnection conn) async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        conn.apiKey, headers, API_SECURITY_TYPE.userData);

    final options = Options(headers: headers);

    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, {}, API_SECURITY_TYPE.userData);

    late final Response<String> response;
    try {
      response = await _ref.read(dioProvider).get('${conn.url}/api/v3/account',
          options: options, queryParameters: secureQuery);
    } on DioError catch (_) {
      return Future.error(_ref
          .read(_apiUtilsProvider)
          .buildApiException('getAccountInformation', response));
    }

    final res = ApiResponse(
        AccountInformation.fromJson(jsonDecode(response.data!)),
        response.statusCode!);
    return res;
  }
}
