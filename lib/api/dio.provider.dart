part of api;

final _dioProvider = Provider<dio.Dio>((_) {
  final _dio = dio.Dio();
  return _dio;
});
