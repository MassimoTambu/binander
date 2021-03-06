import 'package:binander/api/api.dart';
import 'package:binander/modules/settings/providers/settings.provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final binancePubNetStatusProvider =
    FutureProvider.autoDispose<ApiResponse<ApiKeyPermission>>((ref) async {
  final pubConn = ref.watch(settingsProvider.select((p) => p.pubNetConnection));
  return await ref
      .read(apiProvider)
      .spot
      .wallet
      .getPubNetApiKeyPermission(pubConn);
});
