part of 'api.dart';

final _dioProvider = Provider<Dio>((_) {
  final dio = Dio();
  return dio;
});
