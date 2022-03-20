part of api;

class ApiException implements Exception {
  final String method;
  final int statusCode;
  final String? reasonPhrase;
  const ApiException(this.method, this.statusCode, this.reasonPhrase);

  @override
  String toString() {
    if (reasonPhrase != null && reasonPhrase!.isNotEmpty) {
      return '$statusCode - $reasonPhrase. Method: $method';
    }

    return '$statusCode - An error occurred at method $method';
  }
}
