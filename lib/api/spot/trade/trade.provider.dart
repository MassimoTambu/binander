part of api;

final _tradeProvider = Provider<TradeProvider>((ref) {
  return TradeProvider(ref);
});

class TradeProvider {
  final Ref _ref;
  late final ApiUtils apiUtils = _ref.read(_apiUtilsProvider);

  TradeProvider(this._ref);

  Future<ApiResponse<AccountInformation>> getAccountInformation(
      ApiConnection conn) async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        conn.apiKey, headers, API_SECURITY_TYPE.userData);

    final options = Options(headers: headers);

    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, {}, API_SECURITY_TYPE.userData);

    try {
      final response = await _ref.read(_dioProvider).get<Map<String, dynamic>>(
          '${conn.url}/api/v3/account',
          options: options,
          queryParameters: secureQuery);

      return ApiResponse(
          AccountInformation.fromJson(response.data!), response.statusCode!);
    } on DioError catch (e) {
      return Future.error(_ref
          .read(_apiUtilsProvider)
          .buildApiException('getAccountInformation', e));
    }
  }

  Future<ApiResponse<List<Order>>> getAllOrders(
      ApiConnection conn, CryptoSymbol symbol) async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        conn.apiKey, headers, API_SECURITY_TYPE.userData);

    final options = Options(headers: headers);

    final query = {'symbol': symbol.toString()};
    // 'symbol=$symbol&timestamp=$timestamp&signature=';
    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, query, API_SECURITY_TYPE.userData);

    try {
      final response = await _ref.read(_dioProvider).get<String>(
          '${conn.url}/api/v3/allOrders',
          options: options,
          queryParameters: secureQuery);

      final rawOrders = jsonDecode(response.data!) as List<dynamic>;

      return ApiResponse(rawOrders.map((o) => Order.fromJson(o)).toList(),
          response.statusCode!);
    } on DioError catch (e) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('getAllorders', e));
    }
  }

  Future<ApiResponse<OrderData>> getQueryOrder(
      ApiConnection conn, CryptoSymbol symbol, int orderId) async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        conn.apiKey, headers, API_SECURITY_TYPE.userData);

    final options = Options(headers: headers);

    final query = {'symbol': symbol.toString(), 'orderId': orderId.toString()};

    // 'symbol=$symbol&timestamp=$timestamp&signature=';
    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, query, API_SECURITY_TYPE.userData);

    try {
      final response = await _ref.read(_dioProvider).get<String>(
          '${conn.url}/api/v3/order',
          options: options,
          queryParameters: secureQuery);

      return ApiResponse(
          OrderData.fromJson(jsonDecode(response.data!)), response.statusCode!);
    } on DioError catch (e) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('_newOrder', e));
    }
  }

  Future<ApiResponse<OrderCancel>> cancelOrder(
    ApiConnection conn,
    CryptoSymbol symbol,
    int orderId,
  ) async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        conn.apiKey, headers, API_SECURITY_TYPE.userData);

    final options = Options(headers: headers);

    final query = {
      'symbol': symbol.toString(),
      'orderId': orderId.toString(),
    };
    // 'symbol=$symbol&timestamp=$timestamp&signature=';
    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, query, API_SECURITY_TYPE.userData);

    try {
      final response = await _ref.read(_dioProvider).delete<String>(
          '${conn.url}/api/v3/order',
          options: options,
          queryParameters: secureQuery);

      return ApiResponse(OrderCancel.fromJson(jsonDecode(response.data!)),
          response.statusCode!);
    } on DioError catch (e) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('_newOrder', e));
    }
  }

  Future<ApiResponse<OrderNewLimit>> newLimitOrder(
    ApiConnection conn,
    CryptoSymbol symbol,
    OrderSides side,
    double quantity,
    double price, {
    TimeInForce timeInForce = TimeInForce.GTC,
  }) async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        conn.apiKey, headers, API_SECURITY_TYPE.userData);

    final options = Options(headers: headers);

    final query = {
      'symbol': symbol.toString(),
      'side': side.name,
      'type': OrderTypes.LIMIT.name,
      'quantity': quantity.toString(),
      'price': price.toString(),
      'timeInForce': timeInForce.name,
    };

    // 'symbol=$symbol&timestamp=$timestamp&signature=';
    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, query, API_SECURITY_TYPE.userData);

    try {
      final response = await _ref.read(_dioProvider).post<String>(
          '${conn.url}/api/v3/order',
          options: options,
          queryParameters: secureQuery);

      return ApiResponse(OrderNewLimit.fromJson(jsonDecode(response.data!)),
          response.statusCode!);
    } on DioError catch (e) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('_newOrder', e));
    }
  }

  Future<ApiResponse<OrderNewStopLimit>> newStopLimitOrder(
    ApiConnection conn,
    CryptoSymbol symbol,
    OrderSides side,
    double quantity,
    double price,
    double stopPrice, {
    TimeInForce timeInForce = TimeInForce.GTC,
  }) async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        conn.apiKey, headers, API_SECURITY_TYPE.userData);

    final options = Options(headers: headers);

    final query = {
      'symbol': symbol.toString(),
      'side': side.name,
      'type': OrderTypes.STOP_LOSS_LIMIT.name,
      'quantity': quantity.toString(),
      'price': price.toString(),
      'stopPrice': stopPrice.toString(),
      'timeInForce': timeInForce.name,
    };

    // 'symbol=$symbol&timestamp=$timestamp&signature=';
    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, query, API_SECURITY_TYPE.userData);

    try {
      final response = await _ref.read(_dioProvider).post<String>(
          '${conn.url}/api/v3/order',
          options: options,
          queryParameters: secureQuery);

      return ApiResponse(OrderNewStopLimit.fromJson(jsonDecode(response.data!)),
          response.statusCode!);
    } on DioError catch (e) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('_newOrder', e));
    }
  }
}
