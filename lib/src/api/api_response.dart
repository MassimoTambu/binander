part of 'api.dart';

@freezed
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse(
    T body,
    int statusCode,
  ) = _ApiResponse;
}
