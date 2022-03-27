part of api;

final apiProvider = Provider<ApiProvider>((ref) {
  final spot = ref.watch(_spotProvider);

  return ApiProvider(spot);
});

class ApiProvider {
  final SpotProvider spot;

  const ApiProvider(this.spot);
}
