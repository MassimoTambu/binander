part of api;

class ApiResponse<T> {
  final T body;
  final int statusCode;

  const ApiResponse(this.body, this.statusCode);
}
