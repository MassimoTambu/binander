part of api;

final _tradeProvider = Provider<Trade>((ref) {
  return Trade(ref);
});

class Trade {
  final Ref ref;

  Trade(this.ref);

  Future<String> getOrders(ApiConnection conn, String symbol) async {
    late final ApiUtils apiUtils = ref.read(_apiUtilsProvider);
    final query = {'symbol': symbol};
    // 'symbol=$symbol&timestamp=$timestamp&signature=';

    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, query, API_SECURITY_TYPE.userData);

    final request =
        Request('GET', Uri.parse('${conn.url}/allOrders?$secureQuery'));

    apiUtils.addSecurityToHeader(
        conn.apiKey, request, API_SECURITY_TYPE.userData);

    StreamedResponse response = await request.send();

    if (response.statusCode != HttpStatus.ok) {
      apiUtils.throwApiException('getOrders', response.reasonPhrase);
    }

    return await response.stream.bytesToString();
  }

//   Future<String> createOrder(
//     String symbol,
//     OrderSides side,
//     OrderTypes type,
//     double quantity,
//     double price, {
//     TimeInForce timeInForce = TimeInForce.GTC,
//   }) async {
//     final url = read(settingsProvider).apiUrl;
// //     var headers = {
// //   'Content-Type': 'application/json',
// //   'X-MBX-APIKEY': 'api-key'
// // };
//     var request = http.Request(
//         'POST',
//         Uri.parse(
//             'https://api.binance.com/api/v3/order?symbol=BTCUSDT&side=SELL&type=LIMIT&quantity=0.01&price=9000&timestamp=&signature='));

//     request.headers.addAll(headers);

//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       print(await response.stream.bytesToString());
//     } else {
//       print(response.reasonPhrase);
//       return "";
//     }
//   }
}
