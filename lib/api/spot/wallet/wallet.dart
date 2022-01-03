part of api;

final _walletProvider = Provider<Wallet>((ref) {
  return Wallet(ref.read);
});

class Wallet {
  final Reader read;

  const Wallet(this.read);

  /// Check Api status
  Future<ApiResponse> getApiKeyPermission() async {
    final url = read(settingsProvider).apiUrl;
    final apiUtils = read(_apiUtilsProvider);

    final secureQuery =
        apiUtils.createQueryWithSecurity({}, API_SECURITY_TYPE.userData);

    final request = Request(
        'GET', Uri.parse('$url/sapi/v1/account/apiRestrictions?$secureQuery'));

    apiUtils.addSecurityToHeader(request, API_SECURITY_TYPE.userData);

    StreamedResponse response = await request.send();

    if (response.statusCode != HttpStatus.ok) {
      apiUtils.throwApiException('getApiKeyPermission', response.reasonPhrase);
    }

    final body = await response.stream.bytesToString();

    final res = ApiResponse(apiUtils._toJson(body), response.statusCode);
    return res;
  }
}
