part of api;

final _walletProvider = Provider<Wallet>((ref) {
  return Wallet(ref.read);
});

class Wallet {
  final Reader read;

  const Wallet(this.read);

  /// Check Api status
  Future<ApiResponse> getPubNetApiKeyPermission(ApiConnection conn) async {
    final apiUtils = read(_apiUtilsProvider);

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
      // apiUtils.throwApiException('getApiKeyPermission', response.reasonPhrase);
      // final res = ApiResponse('getApiKeyPermission', response.statusCode);
      return Future.error(
        {response.reasonPhrase},
        StackTrace.fromString('getApiKeyPermission'),
      );
    }

    final body = await response.stream.bytesToString();

    final res = ApiResponse(apiUtils._toJson(body), response.statusCode);
    return res;
  }
}
