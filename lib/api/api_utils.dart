part of api;

final _apiUtilsProvider = Provider<ApiUtils>((ref) {
  return ApiUtils(ref.read);
});

class ApiUtils {
  final Reader read;

  const ApiUtils(this.read);

  String createQueryWithSecurity(
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

  void addSecurityToHeader(Request request, API_SECURITY_TYPE securityType) {
    final apiKey = read(settingsProvider).apiKey;

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

  Map<String, dynamic> _toJson(String body) {
    return json.decode(body);
  }

  void _addTimestamp(Map<String, String> query) {
    query['timestamp'] = _generateTimeStamp().toString();
  }

  void _addSignature(Map<String, String> query) {
    query['signature'] = _generateSignature(query);
  }

  int _generateTimeStamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  String _generateSignature(Map<String, String> queryParams) {
    final apiSecret = read(settingsProvider).apiSecret;

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

  String _mapToString(Map<String, String> query) {
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

  void throwApiException(String method, String? reasonPhrase) {
    if (reasonPhrase != null && reasonPhrase.isNotEmpty) {
      throw ApiException('$reasonPhrase. Method: $method');
    }

    throw ApiException('An error occurred at method $method');
  }
}
