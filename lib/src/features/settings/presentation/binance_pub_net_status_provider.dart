import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/settings/presentation/settings_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final binancePubNetStatusProvider =
    FutureProvider.autoDispose<ApiResponse<ApiKeyPermission>>((ref) async {
  final pubConn = ref.watch(settingsProvider.select((p) => p.pubNetConnection));
  return await ref
      .read(apiProvider)
      .spot
      .wallet
      .getPubNetApiKeyPermission(pubConn);
});
