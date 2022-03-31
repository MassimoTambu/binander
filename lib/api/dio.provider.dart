part of api;

final dioProvider = Provider<dio.Dio>((_) {
  final _dio = dio.Dio();
  return _dio;
});
