part of providers;

final binancePubNetStatusProvider =
    FutureProvider.autoDispose<ApiResponse>((ref) async {
  final pubConn = ref.watch(settingsProvider.select((p) => p.pubNetConnection));
  return await ref
      .read(apiProvider)
      .spot
      .wallet
      .getPubNetApiKeyPermission(pubConn);
});
