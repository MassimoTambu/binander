part of api;

class ApiResponse {
  final Map<String, dynamic> body;
  final int statusCode;

  const ApiResponse(this.body, this.statusCode);
}
