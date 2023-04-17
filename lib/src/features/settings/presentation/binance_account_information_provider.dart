import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/settings/domain/api_connection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'binance_account_information_provider.g.dart';

@riverpod
Future<ApiResponse<AccountInformation>> binanceAccountInformation(
    BinanceAccountInformationRef ref, ApiConnection apiConnection) async {
  final response = await ref
      .read(binanceApiProvider(apiConnection))
      .spot
      .trade
      .getAccountInformation();

  // Remove empty balances and sort
  response.body.balances
    ..removeWhere((b) => b.free == 0 && b.locked == 0)
    ..sort(((a, b) => a.asset.compareTo(b.asset)));

  return response;
}
