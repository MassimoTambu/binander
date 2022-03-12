part of api;

final _walletProvider = Provider<Wallet>((ref) {
  return Wallet(ref.read);
});

class Wallet {
  final Reader _read;

  const Wallet(this._read);

  Future<ApiResponse<SystemStatus>> getSystemStatus(ApiConnection conn) async {
    final request =
        Request('GET', Uri.parse('${conn.url}/sapi/v1/system/status'));

    final response = await request.send();

    if (response.statusCode != HttpStatus.ok) {
      return Future.error(
        {response.reasonPhrase},
        StackTrace.fromString('getSystemStatus'),
      );
    }

    final body = await response.stream.bytesToString();

    final res = ApiResponse(
        SystemStatus.fromJson(jsonDecode(body)), response.statusCode);
    return res;
  }

  /// Check ApiKey Permission status
  Future<ApiResponse<ApiKeyPermission>> getPubNetApiKeyPermission(
      ApiConnection conn) async {
    final apiUtils = _read(_apiUtilsProvider);

    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, {}, API_SECURITY_TYPE.userData);

    final request = Request('GET',
        Uri.parse('${conn.url}/sapi/v1/account/apiRestrictions?$secureQuery'));

    apiUtils.addSecurityToHeader(
        conn.apiKey, request, API_SECURITY_TYPE.userData);

    late final StreamedResponse response;
    try {
      response = await request.send();
    } catch (e) {
      return Future.error(
        {e.toString()},
        StackTrace.fromString('getApiKeyPermission'),
      );
    }

    if (response.statusCode != HttpStatus.ok) {
      return Future.error(
        {response.reasonPhrase},
        StackTrace.fromString('getApiKeyPermission'),
      );
    }

    final body = await response.stream.bytesToString();

    final res = ApiResponse(
        ApiKeyPermission.fromJson(jsonDecode(body)), response.statusCode);
    return res;
  }
}
