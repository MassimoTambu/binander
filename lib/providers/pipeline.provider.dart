part of providers;

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
    state.firstWhere((p) => p.bot.uuid == uuid).bot.pipelineData.status =
        status;
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
    required String symbol,
    required int dailyLossSellOrders,
    required double maxQuantityPerOrder,
    required double percentageSellOrder,
    required Duration timerBuyOrder,
  }) {
    final bot = MinimizeLossesBot(
      const Uuid().v4(),
      MinimizeLossesPipeLineData(),
      name: name,
      testNet: testNet,
      config: MinimizeLossesConfig.create(
        dailyLossSellOrders: dailyLossSellOrders,
        maxQuantityPerOrder: maxQuantityPerOrder,
        percentageSellOrder: percentageSellOrder,
        symbol: symbol,
        timerBuyOrder: timerBuyOrder,
      ),
    );

    final pipeline = MinimizeLossesPipeline(_ref, bot);

    state = [...state, pipeline];

    return bot;
  }

  void removeBot() {
    /// TODO implement remove
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

  void _saveBot(Bot bot) {
    _ref.read(fileStorageProvider).upsertBots([bot]);
  }
}
