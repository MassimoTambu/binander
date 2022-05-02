part of api;

final _walletProvider = Provider<WalletProvider>((ref) {
  return WalletProvider(ref);
});

class WalletProvider {
  final Ref _ref;

  const WalletProvider(this._ref);

  Future<ApiResponse<SystemStatus>> getSystemStatus(ApiConnection conn) async {
    late final Response<String> response;

    try {
      response = await _ref
          .read(_dioProvider)
          .get('${conn.url}/sapi/v1/system/status');
    } on DioError catch (_) {
      return Future.error(_ref
          .read(_apiUtilsProvider)
          .buildApiException('getSystemStatus', response));
    }

    final res = ApiResponse(
      SystemStatus.fromJson(jsonDecode(response.data!)),
      response.statusCode!,
    );
    return res;
  }

  /// Check ApiKey Permission status
  Future<ApiResponse<ApiKeyPermission>> getPubNetApiKeyPermission(
      ApiConnection conn) async {
    final apiUtils = _ref.read(_apiUtilsProvider);

    final headers = <String, dynamic>{};

    apiUtils.addSecurityToHeader(
        conn.apiKey, headers, API_SECURITY_TYPE.userData);

    final options = Options(headers: headers);

    final secureQuery = apiUtils.createQueryWithSecurity(
        conn.apiSecret, {}, API_SECURITY_TYPE.userData);

    late final Response<String> response;
    try {
      response = await _ref.read(_dioProvider).get(
          '${conn.url}/sapi/v1/account/apiRestrictions',
          options: options,
          queryParameters: secureQuery);
    } on DioError catch (_) {
      return Future.error(_ref
          .read(_apiUtilsProvider)
          .buildApiException('getSystemStatus', response));
    }

    final res = ApiResponse(
      ApiKeyPermission.fromJson(jsonDecode(response.data!)),
      response.statusCode!,
    );
    return res;
  }
}
