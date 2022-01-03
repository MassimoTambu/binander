part of settings_module;

final binanceStatusProvider = FutureProvider<ApiResponse>((ref) async {
  final content = await ref.read(apiProvider).spot.wallet.getApiKeyPermission();
  return content;
});
