part of settings_module;

@freezed
class ApiConnection with _$ApiConnection {
  const factory ApiConnection({
    required String url,
    required String apiSecret,
    required String apiKey,
  }) = _ApiConnection;
}
