part of settings_module;

final binanceStatusProvider =
    FutureProvider.autoDispose<ApiResponse>((ref) async {
  return await ref.read(apiProvider).spot.wallet.getApiKeyPermission();
});
