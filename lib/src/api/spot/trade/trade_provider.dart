part of '../../api.dart';

@riverpod
Trade _trade(_TradeRef ref, ApiConnection apiConnection) {
  final apiUtils = ref.watch(_apiUtilsProvider);
  return Trade(ref, apiConnection, apiUtils);
}

class Trade {
  final Ref _ref;
  final ApiConnection _conn;
  final ApiUtils apiUtils;

  const Trade(this._ref, this._conn, this.apiUtils);

  Future<ApiResponse<AccountInformation>> getAccountInformation() async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        _conn.apiKey, headers, API_SECURITY_TYPES.userData);

    final options = Options(headers: headers);

    final secureQuery = apiUtils.createQueryWithSecurity(
        _conn.apiSecret, {}, API_SECURITY_TYPES.userData);

    try {
      final response = await _ref.read(_dioProvider).get<Map<String, dynamic>>(
          '${_conn.url}/api/v3/account',
          options: options,
          queryParameters: secureQuery);

      return ApiResponse(
          AccountInformation.fromJson(response.data!), response.statusCode!);
    } catch (e) {
      return Future.error(_ref
          .read(_apiUtilsProvider)
          .buildApiException('getAccountInformation', e));
    }
  }

  Future<ApiResponse<List<Order>>> getAllOrders(CryptoSymbol symbol) async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        _conn.apiKey, headers, API_SECURITY_TYPES.userData);

    final options = Options(headers: headers);

    final query = {'symbol': symbol.toString()};
    // 'symbol=$symbol&timestamp=$timestamp&signature=';
    final secureQuery = apiUtils.createQueryWithSecurity(
        _conn.apiSecret, query, API_SECURITY_TYPES.userData);

    try {
      final response = await _ref.read(_dioProvider).get<List<dynamic>>(
          '${_conn.url}/api/v3/allOrders',
          options: options,
          queryParameters: secureQuery);

      return ApiResponse(response.data!.map((o) => Order.fromJson(o)).toList(),
          response.statusCode!);
    } catch (e) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('getAllorders', e));
    }
  }

  Future<ApiResponse<OrderData>> getQueryOrder(
      CryptoSymbol symbol, int orderId) async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        _conn.apiKey, headers, API_SECURITY_TYPES.userData);

    final options = Options(headers: headers);

    final query = {'symbol': symbol.toString(), 'orderId': orderId.toString()};

    // 'symbol=$symbol&timestamp=$timestamp&signature=';
    final secureQuery = apiUtils.createQueryWithSecurity(
        _conn.apiSecret, query, API_SECURITY_TYPES.userData);

    try {
      final response = await _ref.read(_dioProvider).get<Map<String, dynamic>>(
          '${_conn.url}/api/v3/order',
          options: options,
          queryParameters: secureQuery);

      return ApiResponse(
          OrderData.fromJson(response.data!), response.statusCode!);
    } catch (e) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('_newOrder', e));
    }
  }

  Future<ApiResponse<OrderCancel>> cancelOrder(
    CryptoSymbol symbol,
    int orderId,
  ) async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        _conn.apiKey, headers, API_SECURITY_TYPES.userData);

    final options = Options(headers: headers);

    final query = {
      'symbol': symbol.toString(),
      'orderId': orderId.toString(),
    };
    // 'symbol=$symbol&timestamp=$timestamp&signature=';
    final secureQuery = apiUtils.createQueryWithSecurity(
        _conn.apiSecret, query, API_SECURITY_TYPES.userData);

    try {
      final response = await _ref
          .read(_dioProvider)
          .delete<Map<String, dynamic>>('${_conn.url}/api/v3/order',
              options: options, queryParameters: secureQuery);

      return ApiResponse(
          OrderCancel.fromJson(response.data!), response.statusCode!);
    } catch (e) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('_newOrder', e));
    }
  }

  Future<ApiResponse<OrderNewLimit>> newLimitOrder(
    CryptoSymbol symbol,
    OrderSides side,
    double quantity,
    double price, {
    TimeInForce timeInForce = TimeInForce.GTC,
  }) async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        _conn.apiKey, headers, API_SECURITY_TYPES.userData);

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
        _conn.apiSecret, query, API_SECURITY_TYPES.userData);

    try {
      final response = await _ref.read(_dioProvider).post<Map<String, dynamic>>(
          '${_conn.url}/api/v3/order',
          options: options,
          queryParameters: secureQuery);

      return ApiResponse(
          OrderNewLimit.fromJson(response.data!), response.statusCode!);
    } catch (e) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('_newOrder', e));
    }
  }

  Future<ApiResponse<OrderNewStopLimit>> newStopLimitOrder(
    CryptoSymbol symbol,
    OrderSides side,
    double quantity,
    double price,
    double stopPrice, {
    TimeInForce timeInForce = TimeInForce.GTC,
  }) async {
    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        _conn.apiKey, headers, API_SECURITY_TYPES.userData);

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
        _conn.apiSecret, query, API_SECURITY_TYPES.userData);

    try {
      final response = await _ref.read(_dioProvider).post<Map<String, dynamic>>(
          '${_conn.url}/api/v3/order',
          options: options,
          queryParameters: secureQuery);

      return ApiResponse(
          OrderNewStopLimit.fromJson(response.data!), response.statusCode!);
    } catch (e) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('_newOrder', e));
    }
  }
}
