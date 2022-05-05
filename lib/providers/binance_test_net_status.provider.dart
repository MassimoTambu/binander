part of providers;

final binanceTestNetStatusProvider =
    FutureProvider.autoDispose<ApiResponse<AccountInformation>>((ref) async {
  final testConn =
      ref.watch(settingsProvider.select((p) => p.testNetConnection));
  return await ref.read(apiProvider).spot.trade.getAccountInformation(testConn);
});
