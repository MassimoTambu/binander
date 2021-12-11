part of api;

class ApiUtils {
  static final settingsService = SettingsService();

  static String createQueryWithSecurity(
    Map<String, String> query,
    API_SECURITY_TYPE securityType,
  ) {
    switch (securityType) {
      case API_SECURITY_TYPE.trade:
      case API_SECURITY_TYPE.margin:
      case API_SECURITY_TYPE.userData:
        _addTimestamp(query);
        _addSignature(query);
        break;
      // No security query needed for none, userStream and marketData types
      default:
        break;
    }

    return _mapToString(query);
  }

  static void addSecurityToHeader(
      Request request, API_SECURITY_TYPE securityType) {
    final apiKey = settingsService.apiKey;

    switch (securityType) {
      case API_SECURITY_TYPE.trade:
      case API_SECURITY_TYPE.margin:
      case API_SECURITY_TYPE.userData:
      case API_SECURITY_TYPE.userStream:
      case API_SECURITY_TYPE.marketData:
        final headers = {
          'Content-Type': 'application/json',
          'X-MBX-APIKEY': apiKey
        };

        request.headers.addAll(headers);
        break;
      // No security header needed for none type
      default:
        break;
    }
  }

  static void _addTimestamp(Map<String, String> query) {
    query['timestamp'] = _generateTimeStamp().toString();
  }

  static void _addSignature(Map<String, String> query) {
    query['signature'] = _generateSignature(query);
  }

  static int _generateTimeStamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static String _generateSignature(Map<String, String> queryParams) {
    final apiSecret = settingsService.apiSecret;

    var queryString = "";

    queryParams.forEach((key, value) {
      if (key != 'signature' && key != 'timestamp' && value.isNotEmpty) {
        queryString += '$key=$value&';
      }
    });

    queryString += 'timestamp=' + queryParams['timestamp']!;

    final encodedQuery = utf8.encode(queryString);
    final encodedSecret = utf8.encode(apiSecret);

    final hmacSha256 = Hmac(sha256, encodedSecret);
    final signature = hmacSha256.convert(encodedQuery);

    return signature.toString();
  }

  static String _mapToString(Map<String, String> query) {
    String str = '';
    query.forEach((key, value) {
      if (key == query.keys.last) {
        str += '$key=$value';
      } else {
        str += '$key=$value&';
      }
    });

    return str;
  }

  static void throwApiException(String method, String? reasonPhrase) {
    if (reasonPhrase != null) {
      throw ApiException(reasonPhrase);
    }

    throw ApiException('An error occurred');
  }
}
