import 'package:bottino_fortino/models/crypto_symbol.dart';
import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.config.dart';
import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.pipeline.dart';
import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.pipeline_data.dart';
import 'package:bottino_fortino/modules/bot/models/bot.dart';
import 'package:bottino_fortino/modules/bot/models/bot_status.dart';
import 'package:bottino_fortino/modules/bot/models/bot_types.enum.dart';
import 'package:bottino_fortino/modules/bot/models/interfaces/pipeline.interface.dart';
import 'package:bottino_fortino/modules/bot/models/orders_history.dart';
import 'package:bottino_fortino/providers/exchange_info.provider.dart';
import 'package:bottino_fortino/providers/file_storage.provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:uuid/uuid.dart';

final pipelineProvider =
    StateNotifierProvider<PipelineProvider, List<Pipeline>>((ref) {
  return PipelineProvider(ref);
});

class PipelineProvider extends StateNotifier<List<Pipeline>> {
  final Ref _ref;

  PipelineProvider(this._ref) : super([]) {
    _ref.listen<Map<String, dynamic>>(fileStorageProvider.select((p) => p.data),
        (previous, next) {
      // We can prevent reloading by storinh the hashCode in json and then analyze them
      _loadBotsFromFile(next);
    });

    _loadBotsFromFile(_ref.watch(fileStorageProvider).data);
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

  void addBots(List<Bot> bots) {
    for (final b in bots) {
      var found = false;
      for (var i = 0; i < state.length; i++) {
        if (state[i].bot.uuid == b.uuid) {
          state[i] = _createBotPipeline(b);
          found = true;
        }
      }

      if (found == false) {
        final pipeline = _createBotPipeline(b);
        state.add(pipeline);
      }
    }

    state = [...state];
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
    final precision = _ref
        .read(exchangeInfoProvider)!
        .getSymbolPrecision(symbol.toString(), isTestNet: testNet);

    final bot = MinimizeLossesBot(
      const Uuid().v4(),
      MinimizeLossesPipelineData(
        ordersHistory: OrdersHistory([]),
        symbolPrecision: precision,
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

    final pipeline = MinimizeLossesPipeline(_ref, bot);

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
    _ref
        .read(fileStorageProvider)
        .removeBots(pipelines.map((p) => p.bot).toList());
  }

  void _loadBotsFromFile(Map<String, dynamic> data) {
    if (data.containsKey('bots')) {
      final List<Bot> bots = [];
      for (final bot in data['bots'] as List) {
        bots.add(Bot.fromJson(bot));
      }

      addBots(bots);
    }
  }

  Pipeline _createBotPipeline(Bot bot) {
    return bot.map(
      minimizeLosses: (minimizeLosses) =>
          MinimizeLossesPipeline(_ref, minimizeLosses),
    );
  }
}
