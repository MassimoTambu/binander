part of api;

@freezed
class ApiException with _$ApiException implements Exception {
  const ApiException._();
  const factory ApiException(
    String method,
    int statusCode,
    String? reasonPhrase,
  ) = _ApiException;

  @override
  String toString() {
    if (reasonPhrase != null && reasonPhrase!.isNotEmpty) {
      return '$statusCode - $reasonPhrase. Method: $method';
    }

    return '$statusCode - An error occurred at method $method';
  }
}
