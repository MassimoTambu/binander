part of 'api.dart';

final _apiUtilsProvider = Provider<ApiUtils>((ref) {
  return const ApiUtils();
});

class ApiUtils {
  const ApiUtils();

  Map<String, String> createQueryWithSecurity(
    String apiSecret,
    Map<String, String> query,
    API_SECURITY_TYPES securityType,
  ) {
    switch (securityType) {
      case API_SECURITY_TYPES.trade:
      case API_SECURITY_TYPES.margin:
      case API_SECURITY_TYPES.userData:
        _addTimestamp(query);
        _addSignature(apiSecret, query);
      // No security query needed for none, userStream and marketData types
      default:
        break;
    }

    return query;
  }

  void addSecurityToHeader(
    String apiKey,
    Map<String, dynamic> headers,
    API_SECURITY_TYPES securityType,
  ) {
    switch (securityType) {
      case API_SECURITY_TYPES.trade:
      case API_SECURITY_TYPES.margin:
      case API_SECURITY_TYPES.userData:
      case API_SECURITY_TYPES.userStream:
      case API_SECURITY_TYPES.marketData:
        headers.addAll(
            {'Content-Type': 'application/json', 'X-MBX-APIKEY': apiKey});
      // No security header needed for none type
      default:
        break;
    }
  }

  void _addTimestamp(Map<String, String> query) {
    query['timestamp'] = _generateTimeStamp().toString();
  }

  void _addSignature(String apiSecret, Map<String, String> query) {
    query['signature'] = _generateSignature(apiSecret, query);
  }

  int _generateTimeStamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  String _generateSignature(String apiSecret, Map<String, String> queryParams) {
    var queryString = "";

    queryParams.forEach((key, value) {
      if (key != 'signature' && key != 'timestamp' && value.isNotEmpty) {
        queryString += '$key=$value&';
      }
    });

    queryString += 'timestamp=${queryParams['timestamp']!}';

    final encodedQuery = utf8.encode(queryString);
    final encodedSecret = utf8.encode(apiSecret);

    final hmacSha256 = Hmac(sha256, encodedSecret);
    final signature = hmacSha256.convert(encodedQuery);

    return signature.toString();
  }

  ApiException buildApiException(String method, Object error) {
    if (error is DioError) {
      return ApiException(
        method,
        error.response?.statusCode,
        error.response?.statusMessage,
        error.response?.data,
      );
    }
    return ApiException(method, null, error.toString(), null);
  }
}
