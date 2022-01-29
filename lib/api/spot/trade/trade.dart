part of api;

final _tradeProvider = Provider<Trade>((ref) {
  return Trade(ref);
});

class Trade {
  final Ref ref;
  late final ApiUtils apiUtils = ref.read(_apiUtilsProvider);

  Trade(this.ref);

  Future<ApiResponse<Order>> getOrders(
      ApiConnection conn, String symbol) async {
    final query = {'symbol': symbol};
    // 'symbol=$symbol&timestamp=$timestamp&signature=';

    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, query, API_SECURITY_TYPE.userData);

    final request =
        Request('GET', Uri.parse('${conn.url}/api/v3/allOrders?$secureQuery'));

    apiUtils.addSecurityToHeader(
        conn.apiKey, request, API_SECURITY_TYPE.userData);

    StreamedResponse response = await request.send();

    if (response.statusCode != HttpStatus.ok) {
      return Future.error(
        {response.reasonPhrase},
        StackTrace.fromString('getOrders'),
      );
    }

    final body = await response.stream.bytesToString();

    final res =
        ApiResponse(Order.fromJson(jsonDecode(body)), response.statusCode);

    return res;
  }

  Future<ApiResponse<OrderNew>> createOrder(
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

    StreamedResponse response = await request.send();

    if (response.statusCode != HttpStatus.ok) {
      return Future.error(
        {response.reasonPhrase},
        StackTrace.fromString('createOrder'),
      );
    }

    final body = await response.stream.bytesToString();

    final res =
        ApiResponse(OrderNew.fromJson(jsonDecode(body)), response.statusCode);

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
      return Future.error(
        {response.reasonPhrase},
        StackTrace.fromString('getAccountInformation'),
      );
    }

    final body = await response.stream.bytesToString();

    final res = ApiResponse(
        AccountInformation.fromJson(jsonDecode(body)), response.statusCode);

    return res;
  }
}
