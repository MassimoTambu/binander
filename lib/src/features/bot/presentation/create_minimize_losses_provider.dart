import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/bot/domain/bots/minimize_losses/minimize_losses_pipeline.dart';
import 'package:binander/src/features/bot/domain/create_minimize_losses.dart';
import 'package:binander/src/features/bot/domain/create_minimize_losses_params.dart';
import 'package:binander/src/features/settings/domain/api_connection.dart';
import 'package:binander/src/features/settings/presentation/exchange_info_provider.dart';
import 'package:binander/src/features/settings/presentation/settings_provider.dart';
import 'package:binander/src/models/crypto_symbol.dart';
import 'package:binander/src/utils/floor_to_double_with_decimals.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_minimize_losses_provider.g.dart';

@riverpod
Future<CreateMinimizeLosses> createMinimizeLosses(
    CreateMinimizeLossesRef ref, CreateMinimizeLossesParams params) async {
  final ApiConnection apiConn = params.isTestNet
      ? ref.read(settingsStorageProvider).requireValue.testNetConnection
      : ref.read(settingsStorageProvider).requireValue.pubNetConnection;
  final percentageSellOrder = double.tryParse(params.percentageSellOrder ?? '');
  final symbol = params.symbol;

  if (percentageSellOrder == null || symbol == null || symbol.isEmpty) {
    return Future.error('Invalid params');
  }

  final res = await ref
      .read(binanceApiProvider(apiConn))
      .spot
      .market
      .getAveragePrice(CryptoSymbol(symbol));

  final lastAvgPrice = res.body.price;

  final quantityPrecision = ref
      .read(exchangeInfoProvider)!
      .getOrderPrecision(symbol.toString(), isTestNet: params.isTestNet);

  return CreateMinimizeLosses(
    lastAvgPrice,
    CryptoSymbol(symbol),
    MinimizeLossesPipeline.calculateNewOrderStopPrice(
            lastAvgPrice:
                lastAvgPrice.floorToDoubleWithDecimals(quantityPrecision),
            lastBuyOrderPrice: lastAvgPrice,
            percentageSellOrder: percentageSellOrder)
        .floorToDoubleWithDecimals(quantityPrecision),
  );
}
