part of api;

class Trade {
  static final Trade _singleton = Trade._internal();

  factory Trade() {
    return _singleton;
  }

  Trade._internal();

  Future<String> getOrders(String symbol) async {
    final query = {'symbol': symbol};
    // 'symbol=$symbol&timestamp=$timestamp&signature=';

    final settingsService = SettingsService();
    final url = settingsService.apiUrl;

    final secureQuery =
        ApiUtils.createQueryWithSecurity(query, API_SECURITY_TYPE.userData);

    final request = Request('GET', Uri.parse('$url/allOrders?$secureQuery'));

    ApiUtils.addSecurityToHeader(request, API_SECURITY_TYPE.userData);

    StreamedResponse response = await request.send();

    if (response.statusCode != HttpStatus.ok) {
      ApiUtils.throwApiException('getOrders', response.reasonPhrase);
    }

    return await response.stream.bytesToString();
  }
}
