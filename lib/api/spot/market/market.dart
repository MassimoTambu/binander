part of api;

final _marketProvider = Provider<Market>((ref) {
  return Market(ref);
});

class Market {
  final Ref _ref;
  late final ApiUtils apiUtils = _ref.read(_apiUtilsProvider);

  Market(this._ref);

  Future<ApiResponse<AveragePrice>> getAveragePrice(
      ApiConnection conn, String symbol) async {
    final query = {'symbol': symbol};

    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, query, API_SECURITY_TYPE.none);

    final request =
        Request('GET', Uri.parse('${conn.url}/api/v3/avgPrice?$secureQuery'));

    final response = await request.send();

    if (response.statusCode != HttpStatus.ok) {
      return Future.error(
        {response.reasonPhrase},
        StackTrace.fromString('getAveragePrice'),
      );
    }

    final body = await response.stream.bytesToString();

    final res = ApiResponse(
        AveragePrice.fromJson(jsonDecode(body)), response.statusCode);

    return res;
  }
}
