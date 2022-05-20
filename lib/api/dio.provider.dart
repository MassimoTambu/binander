part of api;

final _dioProvider = Provider<Dio>((_) {
  final dio = Dio();
  return dio;
});
