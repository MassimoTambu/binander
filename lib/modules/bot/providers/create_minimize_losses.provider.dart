import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/models/crypto_symbol.dart';
import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.config.dart';
import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.pipeline.dart';
import 'package:bottino_fortino/modules/bot/models/bot.dart';
import 'package:bottino_fortino/modules/bot/models/create_minimize_losses.dart';
import 'package:bottino_fortino/modules/dashboard/providers/create_bot.provider.dart';
import 'package:bottino_fortino/modules/settings/models/api_connection.dart';
import 'package:bottino_fortino/modules/settings/providers/settings.provider.dart';
import 'package:bottino_fortino/utils/extensions/double.extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createMinimizeLossesProvider =
    FutureProvider.autoDispose<CreateMinimizeLosses>((ref) async {
  final fields =
      ref.watch(createBotProvider.notifier).formKey.currentState!.fields;
  final isTestNet = fields[Bot.testNetName]!.value as bool;
  final ApiConnection apiConn = isTestNet
      ? ref.read(settingsProvider).testNetConnection
      : ref.read(settingsProvider).pubNetConnection;
  final percentageSellOrder = double.tryParse(
      fields[MinimizeLossesConfig.percentageSellOrderName]!.value);
  final symbol = fields[MinimizeLossesConfig.symbolName]!.value as String?;

  if (percentageSellOrder == null || symbol == null || symbol.isEmpty) {
    return Future.error('Invalid params');
  }

  final res = await ref
      .read(apiProvider)
      .spot
      .market
      .getAveragePrice(apiConn, CryptoSymbol(symbol));

  final lastAvgPrice = res.body.price;

  return CreateMinimizeLosses(
    lastAvgPrice,
    CryptoSymbol(symbol),
    MinimizeLossesPipeline.calculateNewOrderStopPrice(
            lastAvgPrice: lastAvgPrice.floorToDoubleWithDecimals(7),
            lastBuyOrderPrice: lastAvgPrice,
            percentageSellOrder: percentageSellOrder)
        .floorToDoubleWithDecimals(7),
  );
});
