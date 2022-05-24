part of api;

final _walletProvider = Provider<WalletProvider>((ref) {
  return WalletProvider(ref);
});

class WalletProvider {
  final Ref _ref;

  const WalletProvider(this._ref);

  Future<ApiResponse<SystemStatus>> getSystemStatus(ApiConnection conn) async {
    try {
      final response = await _ref
          .read(_dioProvider)
          .get<Map<String, dynamic>>('${conn.url}/sapi/v1/system/status');

      return ApiResponse(
        SystemStatus.fromJson(response.data!),
        response.statusCode!,
      );
    } on DioError catch (e) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('getSystemStatus', e));
    }
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

    try {
      final response = await _ref.read(_dioProvider).get<Map<String, dynamic>>(
          '${conn.url}/sapi/v1/account/apiRestrictions',
          options: options,
          queryParameters: secureQuery);

      return ApiResponse(
        ApiKeyPermission.fromJson(response.data!),
        response.statusCode!,
      );
    } on DioError catch (e) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('getSystemStatus', e));
    }
  }
}
