
part of api;

@freezed
class ApiException with _$ApiException implements Exception {
  const ApiException._();
  const factory ApiException(
    String method,
    int? statusCode,
    String? statusMessage,
    Map<String, dynamic>? data,
  ) = _ApiException;

  @override
  String toString() {
    final infos = {
      'StatusCode': statusCode,
      'StatusMessage': statusMessage,
      'Data': data,
      'Method': method,
    };
    infos.removeWhere((_, v) => v == null);

    var message = 'ApiException - ';
    infos.forEach((k, v) {
      message += '$k: $v';
      if (infos.keys.last != k) {
        message += ' - ';
      }
    });

    return message;
  }
}
