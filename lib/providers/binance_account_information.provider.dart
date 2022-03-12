part of providers;

final binanceAccountInformationProvider = FutureProvider.family
    .autoDispose<ApiResponse<AccountInformation>, ApiConnection>(
        (ref, apiConnection) async {
  return await ref
      .read(apiProvider)
      .spot
      .trade
      .getAccountInformation(apiConnection);
});
