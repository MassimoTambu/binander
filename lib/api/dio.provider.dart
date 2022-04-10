part of api;

final _dioProvider = Provider<Dio>((_) {
  final _dio = Dio();
  return _dio;
});
