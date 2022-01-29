part of api;

final _tradeProvider = Provider<Trade>((ref) {
  return Trade(ref.read);
});

class Trade {
  final Reader read;

  const Trade(this.read);

  Future<String> getOrders(String symbol) async {
    final query = {'symbol': symbol};
    // 'symbol=$symbol&timestamp=$timestamp&signature=';

    final url = read(settingsProvider).apiUrl;
    final apiUtils = read(_apiUtilsProvider);

    final secureQuery =
        apiUtils.createQueryWithSecurity(query, API_SECURITY_TYPE.userData);

    final request = Request('GET', Uri.parse('$url/allOrders?$secureQuery'));

    apiUtils.addSecurityToHeader(request, API_SECURITY_TYPE.userData);

    StreamedResponse response = await request.send();

    if (response.statusCode != HttpStatus.ok) {
      apiUtils.throwApiException('getOrders', response.reasonPhrase);
    }

    return await response.stream.bytesToString();
  }

  Future<String> createOrder(String symbol) async {
    return "";
  }
}
