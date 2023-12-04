import 'package:binander/src/features/bot/domain/bots/bot.dart';
import 'package:binander/src/features/bot/domain/bots/bot_status.dart';
import 'package:binander/src/features/bot/domain/bots/bot_types.dart';
import 'package:binander/src/features/bot/domain/bots/minimize_losses/minimize_losses_config.dart';
import 'package:binander/src/features/bot/domain/bots/minimize_losses/minimize_losses_pipeline.dart';
import 'package:binander/src/features/bot/domain/bots/minimize_losses/minimize_losses_pipeline_data.dart';
import 'package:binander/src/features/bot/domain/orders_history.dart';
import 'package:binander/src/features/bot/domain/pipeline.dart';
import 'package:binander/src/features/settings/presentation/exchange_info_provider.dart';
import 'package:binander/src/models/crypto_symbol.dart';
import 'package:binander/src/utils/file_storage_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'pipeline_controller.g.dart';

@riverpod
class PipelineController extends _$PipelineController {
  @override
  List<Pipeline> build() {
    ref.listen<Map<String, dynamic>>(
        fileStorageProvider.select((p) => p.requireValue), (previous, next) {
      // We can prevent reloading by storing the hashCode in json and then analyze them
      state = addBots(_readBotsFromFile(next));
    });

    return _loadBots(
        _readBotsFromFile(ref.watch(fileStorageProvider).requireValue));
  }

  List<Bot> _readBotsFromFile(Map<String, dynamic> data) {
    if (data.containsKey('bots')) {
      final List<Bot> bots = [];
      for (final bot in data['bots'] as List) {
        bots.add(Bot.fromJson(bot));
      }

      return bots;
    }

    return [];
  }

  void updateBotStatus(String uuid, BotStatus status) {
    state.firstWhere((p) => p.bot.uuid == uuid).bot.data.status = status;
    state = [...state];
  }

  Bot createBotFromForm(
      Map<String, FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>>
          fields) {
    late final Bot bot;
    switch (fields['bot_type']!.value) {
      case BotTypes.minimizeLosses:
        bot = createMinimizeLossesBot(
          name: fields[Bot.botNameName]!.value,
          testNet: fields[Bot.testNetName]!.value,
          symbol: CryptoSymbol(fields[MinimizeLossesConfig.symbolName]!.value),
          dailyLossSellOrders: int.parse(
              fields[MinimizeLossesConfig.dailyLossSellOrdersName]!.value),
          maxInvestmentPerOrder: double.parse(
              fields[MinimizeLossesConfig.maxInvestmentPerOrderName]!.value),
          percentageSellOrder: double.parse(
              fields[MinimizeLossesConfig.percentageSellOrderName]!.value),
          timerBuyOrder: Duration(
            minutes: int.parse(
                fields[MinimizeLossesConfig.timerBuyOrderName]!.value),
          ),
          autoRestart: fields[MinimizeLossesConfig.autoRestartName]!.value,
        );
        break;
      default:
        bot = createMinimizeLossesBot(
          name: fields[Bot.botNameName]!.value,
          testNet: fields[Bot.testNetName]!.value,
          symbol: CryptoSymbol(fields[MinimizeLossesConfig.symbolName]!.value),
          dailyLossSellOrders: int.parse(
              fields[MinimizeLossesConfig.dailyLossSellOrdersName]!.value),
          maxInvestmentPerOrder: double.parse(
              fields[MinimizeLossesConfig.maxInvestmentPerOrderName]!.value),
          percentageSellOrder: double.parse(
              fields[MinimizeLossesConfig.percentageSellOrderName]!.value),
          timerBuyOrder: Duration(
            minutes: int.parse(
                fields[MinimizeLossesConfig.timerBuyOrderName]!.value),
          ),
          autoRestart: fields[MinimizeLossesConfig.autoRestartName]!.value,
        );
        break;
    }

    return bot;
  }

  List<Pipeline> _loadBots(List<Bot> bots) {
    return bots.map(_createBotPipeline).toList();
  }

  List<Pipeline> addBots(List<Bot> bots) {
    final List<Pipeline> newBots = [...state];
    for (final b in bots) {
      var found = false;
      for (var i = 0; i < newBots.length; i++) {
        if (newBots[i].bot.uuid == b.uuid) {
          newBots[i] = _createBotPipeline(b);
          found = true;
        }
      }

      if (found == false) {
        final pipeline = _createBotPipeline(b);
        newBots.add(pipeline);
      }
    }
    return newBots;
  }

  MinimizeLossesBot createMinimizeLossesBot({
    required String name,
    required bool testNet,
    required CryptoSymbol symbol,
    required int dailyLossSellOrders,
    required double maxInvestmentPerOrder,
    required double percentageSellOrder,
    required Duration timerBuyOrder,
    required bool autoRestart,
  }) {
    final orderPrecision = ref
        .read(exchangeInfoProvider)!
        .getOrderPrecision(symbol.toString(), isTestNet: testNet);
    final quantityPrecision = ref
        .read(exchangeInfoProvider)!
        .getQuantityPrecision(symbol.toString(), isTestNet: testNet);

    final bot = MinimizeLossesBot(
      const Uuid().v4(),
      MinimizeLossesPipelineData(
        ordersHistory: OrdersHistory([]),
        orderPrecision: orderPrecision,
        quantityPrecision: quantityPrecision,
      ),
      name: name,
      testNet: testNet,
      config: MinimizeLossesConfig.create(
        dailyLossSellOrders: dailyLossSellOrders,
        maxInvestmentPerOrder: maxInvestmentPerOrder,
        percentageSellOrder: percentageSellOrder,
        symbol: symbol,
        timerBuyOrder: timerBuyOrder,
        autoRestart: autoRestart,
      ),
    );

    final pipeline = MinimizeLossesPipeline(ref, bot);

    state = [...state, pipeline];

    return bot;
  }

  Future<void> removeBots(List<String> uuids) async {
    final pipelines = state.where((p) => uuids.any((u) => p.bot.uuid == u));

    // Exit if no pipelines are found
    if (pipelines.isEmpty) return;

    await Future.wait(
        pipelines.map((p) => p.shutdown(reason: 'removing bot..')));

    // Update state removing cancelled bots
    state = [...state.where((p) => uuids.every((u) => p.bot.uuid != u))];
    ref
        .read(fileStorageProvider.notifier)
        .removeBots(pipelines.map((p) => p.bot).toList());
  }

  Pipeline _createBotPipeline(Bot bot) {
    return bot.map(
      minimizeLosses: (minimizeLosses) =>
          MinimizeLossesPipeline(ref, minimizeLosses),
    );
  }
}
