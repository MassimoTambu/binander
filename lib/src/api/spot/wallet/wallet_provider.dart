part of '../../api.dart';

@riverpod
Wallet _wallet(_WalletRef ref, ApiConnection apiConnection) =>
    Wallet(ref, apiConnection, ref.watch(_apiUtilsProvider));

class Wallet {
  final Ref _ref;
  final ApiConnection _conn;
  final ApiUtils _apiUtils;

  const Wallet(this._ref, this._conn, this._apiUtils);

  Future<ApiResponse<SystemStatus>> getSystemStatus() async {
    try {
      final response = await _ref
          .read(_dioProvider)
          .get<Map<String, dynamic>>('${_conn.url}/sapi/v1/system/status');

      return ApiResponse(
        SystemStatus.fromJson(response.data!),
        response.statusCode!,
      );
    } catch (e) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('getSystemStatus', e));
    }
  }

  /// Check ApiKey Permission status
  Future<ApiResponse<ApiKeyPermission>> getPubNetApiKeyPermission() async {
    final headers = <String, dynamic>{};

    _apiUtils.addSecurityToHeader(
        _conn.apiKey, headers, API_SECURITY_TYPES.userData);

    final options = Options(headers: headers);

    final secureQuery = _apiUtils.createQueryWithSecurity(
        _conn.apiSecret, {}, API_SECURITY_TYPES.userData);

    try {
      final response = await _ref.read(_dioProvider).get<Map<String, dynamic>>(
          '${_conn.url}/sapi/v1/account/apiRestrictions',
          options: options,
          queryParameters: secureQuery);

      return ApiResponse(
        ApiKeyPermission.fromJson(response.data!),
        response.statusCode!,
      );
    } catch (e) {
      return Future.error(
          _ref.read(_apiUtilsProvider).buildApiException('getSystemStatus', e));
    }
  }
}
