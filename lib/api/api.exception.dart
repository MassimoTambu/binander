part of api;

class ApiException implements Exception {
  final String cause;
  const ApiException(this.cause);

  @override
  String toString() {
    return cause;
  }
}
