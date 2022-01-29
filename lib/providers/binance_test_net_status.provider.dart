part of providers;

final binanceTestNetStatusProvider =
    FutureProvider.autoDispose<ApiResponse>((ref) async {
  final testConn =
      ref.watch(settingsProvider.select((p) => p.testNetConnection));
  return await ref.read(apiProvider).spot.trade.getAccountInformation(testConn);
});
