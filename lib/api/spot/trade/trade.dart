part of api;

final _tradeProvider = Provider<Trade>((ref) {
  return Trade(ref);
});

class Trade {
  final Ref _ref;
  late final ApiUtils apiUtils = _ref.read(_apiUtilsProvider);

  Trade(this._ref);

  Future<ApiResponse<List<Order>>> getAllOrders(
      ApiConnection conn, String symbol) async {
    final query = {'symbol': symbol};
    // 'symbol=$symbol&timestamp=$timestamp&signature=';

    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, query, API_SECURITY_TYPE.userData);

    final request =
        Request('GET', Uri.parse('${conn.url}/api/v3/allOrders?$secureQuery'));

    apiUtils.addSecurityToHeader(
        conn.apiKey, request, API_SECURITY_TYPE.userData);

    final response = await request.send();

    if (response.statusCode != HttpStatus.ok) {
      return Future.error(_ref
          .read(_apiUtilsProvider)
          .buildApiException('getAllOrders', response));
    }

    final body = await response.stream.bytesToString();
    final rawOrders = jsonDecode(body) as List<dynamic>;

    final res = ApiResponse(
        rawOrders.map((o) => Order.fromJson(o)).toList(), response.statusCode);

    return res;
  }

  Future<ApiResponse<Order>> getQueryOrder(
      ApiConnection conn, String symbol, int orderId) async {
    final query = {'symbol': symbol, 'orderId': orderId.toString()};
    // 'symbol=$symbol&timestamp=$timestamp&signature=';

    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, query, API_SECURITY_TYPE.userData);

    final request =
        Request('GET', Uri.parse('${conn.url}/api/v3/order?$secureQuery'));

    apiUtils.addSecurityToHeader(
        conn.apiKey, request, API_SECURITY_TYPE.userData);

    final response = await request.send();

    if (response.statusCode != HttpStatus.ok) {
      return Future.error(_ref
          .read(_apiUtilsProvider)
          .buildApiException('getQueryOrder', response));
    }

    final body = await response.stream.bytesToString();

    final res =
        ApiResponse(Order.fromJson(jsonDecode(body)), response.statusCode);

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
    final query = {
      'symbol': symbol,
      'side': side.name,
      'type': type.name,
      'quantity': quantity.toString(),
      'price': price.toString(),
      'timeInForce': timeInForce.name,
    };

    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, query, API_SECURITY_TYPE.userData);

    final request =
        Request('POST', Uri.parse('${conn.url}/api/v3/order?$secureQuery'));

    apiUtils.addSecurityToHeader(
        conn.apiKey, request, API_SECURITY_TYPE.userData);

    final response = await request.send();

    if (response.statusCode != HttpStatus.ok) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('newOrder', response));
    }

    final body = await response.stream.bytesToString();

    final res =
        ApiResponse(OrderNew.fromJson(jsonDecode(body)), response.statusCode);

    return res;
  }

  Future<ApiResponse<OrderCancel>> cancelOrder(
    ApiConnection conn,
    String symbol,
    int orderId,
  ) async {
    final query = {
      'symbol': symbol,
      'orderId': orderId.toString(),
    };

    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, query, API_SECURITY_TYPE.userData);

    final request =
        Request('DELETE', Uri.parse('${conn.url}/api/v3/order?$secureQuery'));

    apiUtils.addSecurityToHeader(
        conn.apiKey, request, API_SECURITY_TYPE.userData);

    final response = await request.send();

    if (response.statusCode != HttpStatus.ok) {
      return Future.error(_ref
          .read(_apiUtilsProvider)
          .buildApiException('cancelOrder', response));
    }

    final body = await response.stream.bytesToString();

    final res = ApiResponse(
        OrderCancel.fromJson(jsonDecode(body)), response.statusCode);

    return res;
  }

  Future<ApiResponse<AccountInformation>> getAccountInformation(
      ApiConnection conn) async {
    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, {}, API_SECURITY_TYPE.userData);

    final request =
        Request('GET', Uri.parse('${conn.url}/api/v3/account?$secureQuery'));

    apiUtils.addSecurityToHeader(
        conn.apiKey, request, API_SECURITY_TYPE.userData);

    final response = await request.send();

    if (response.statusCode != HttpStatus.ok) {
      return Future.error(_ref
          .read(_apiUtilsProvider)
          .buildApiException('getAccountInformation', response));
    }

    final body = await response.stream.bytesToString();

    final res = ApiResponse(
        AccountInformation.fromJson(jsonDecode(body)), response.statusCode);

    return res;
  }
}
