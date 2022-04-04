part of api;

final dioProvider = Provider<Dio>((_) {
  final _dio = Dio();
  return _dio;
});
