import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/modules/settings/providers/settings.provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final binanceTestNetStatusProvider =
    FutureProvider.autoDispose<ApiResponse<AccountInformation>>((ref) async {
  final testConn =
      ref.watch(settingsProvider.select((p) => p.testNetConnection));
  return await ref.read(apiProvider).spot.trade.getAccountInformation(testConn);
});
