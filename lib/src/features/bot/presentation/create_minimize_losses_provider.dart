import 'package:binander/api/api.dart';
import 'package:binander/models/crypto_symbol.dart';
import 'package:binander/modules/bot/bots/minimize_losses/minimize_losses.pipeline.dart';
import 'package:binander/modules/bot/models/create_minimize_losses.dart';
import 'package:binander/modules/bot/models/create_minimize_losses_params.dart';
import 'package:binander/modules/settings/models/api_connection.dart';
import 'package:binander/modules/settings/providers/settings.provider.dart';
import 'package:binander/providers/exchange_info.provider.dart';
import 'package:binander/utils/extensions/double.extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createMinimizeLossesProvider = FutureProvider.autoDispose
    .family<CreateMinimizeLosses, CreateMinimizeLossesParams>(
        (ref, params) async {
  final ApiConnection apiConn = params.isTestNet
      ? ref.read(settingsProvider).testNetConnection
      : ref.read(settingsProvider).pubNetConnection;
  final percentageSellOrder = double.tryParse(params.percentageSellOrder ?? '');
  final symbol = params.symbol;

  if (percentageSellOrder == null || symbol == null || symbol.isEmpty) {
    return Future.error('Invalid params');
  }

  final res = await ref
      .read(apiProvider)
      .spot
      .market
      .getAveragePrice(apiConn, CryptoSymbol(symbol));

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
});
