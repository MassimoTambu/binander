part of providers;

final binanceAccountInformationProvider = FutureProvider.family
    .autoDispose<ApiResponse<AccountInformation>, ApiConnection>(
        (ref, apiConnection) async {
  final response = await ref
      .read(apiProvider)
      .spot
      .trade
      .getAccountInformation(apiConnection);

  // Remove empty balances and sort
  response.body.balances
    ..removeWhere((b) => b.free == 0 && b.locked == 0)
    ..sort(((a, b) => a.asset.compareTo(b.asset)));

  return response;
});
