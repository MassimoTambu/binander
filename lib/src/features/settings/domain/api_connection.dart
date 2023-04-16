import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_connection.freezed.dart';

@freezed
class ApiConnection with _$ApiConnection {
  const factory ApiConnection({
    required String url,
    required String apiSecret,
    required String apiKey,
  }) = _ApiConnection;
}
