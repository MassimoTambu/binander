part of providers;

final botProvider = StateNotifierProvider<BotProvider, List<Bot>>((ref) {
  return BotProvider(ref);
});

class BotProvider extends StateNotifier<List<Bot>> {
  final Ref _ref;

  BotProvider(this._ref) : super([]) {
    _ref.listen<Map<String, dynamic>>(fileStorageProvider.select((p) => p.data),
        (previous, next) {
      // We can prevent reloading by storinh the hashCode in json and then analyze them
      _loadBotsFromFile(next);
    });

    _loadBotsFromFile(_ref.watch(fileStorageProvider).data);
  }

  void updateBotStatus(String uuid, BotStatus status) {
    state.firstWhere((b) => b.uuid == uuid).status = status;
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
          symbol: fields[MinimizeLossesConfig.symbolName]!.value,
          dailyLossSellOrders: int.parse(
              fields[MinimizeLossesConfig.dailyLossSellOrdersName]!.value),
          maxQuantityPerOrder: double.parse(
              fields[MinimizeLossesConfig.maxInvestmentPerOrderName]!.value),
          percentageSellOrder: double.parse(
              fields[MinimizeLossesConfig.percentageSellOrderName]!.value),
          timerBuyOrder: Duration(
            minutes: int.parse(
                fields[MinimizeLossesConfig.timerBuyOrderName]!.value),
          ),
        );
        break;
      default:
        bot = createMinimizeLossesBot(
          name: fields[Bot.botNameName]!.value,
          testNet: fields[Bot.testNetName]!.value,
          symbol: fields[MinimizeLossesConfig.symbolName]!.value,
          dailyLossSellOrders: int.parse(
              fields[MinimizeLossesConfig.dailyLossSellOrdersName]!.value),
          maxQuantityPerOrder: double.parse(
              fields[MinimizeLossesConfig.maxInvestmentPerOrderName]!.value),
          percentageSellOrder: double.parse(
              fields[MinimizeLossesConfig.percentageSellOrderName]!.value),
          timerBuyOrder: Duration(
            minutes: int.parse(
                fields[MinimizeLossesConfig.timerBuyOrderName]!.value),
          ),
        );
        break;
    }

    _saveBot(bot);

    return bot;
  }

  void addBots(List<Bot> bots) {
    for (final b in bots) {
      var found = false;
      for (var i = 0; i < state.length; i++) {
        if (state[i].uuid == b.uuid) {
          state[i] = b;
          found = true;
        }
      }

      if (found == false) {
        state.add(b);
      }
    }

    state = [...state];
  }

  MinimizeLossesBot createMinimizeLossesBot({
    required String name,
    required bool testNet,
    required String symbol,
    required int dailyLossSellOrders,
    required double maxQuantityPerOrder,
    required double percentageSellOrder,
    required Duration timerBuyOrder,
  }) {
    final bot = MinimizeLossesBot.create(
      name: name,
      testNet: testNet,
      symbol: symbol,
      dailyLossSellOrders: dailyLossSellOrders,
      maxQuantityPerOrder: maxQuantityPerOrder,
      percentageSellOrder: percentageSellOrder,
      timerBuyOrder: timerBuyOrder,
    );

    state = <Bot>[...state, bot];

    return bot;
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

  void _saveBot(Bot bot) {
    _ref.read(fileStorageProvider).upsertBots([bot]);
  }
}
