part of dashboard_module;

final createBotProvider =
    StateNotifierProvider<CreateBotProvider, BotTypes>((ref) {
  return CreateBotProvider(ref);
});

class CreateBotProvider extends StateNotifier<BotTypes> {
  final Ref ref;

  CreateBotProvider(this.ref) : super(BotTypes.minimizeLosses);
  void createBot(
      Map<String, FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>>
          fields) {
    final bot = ref.read(botProvider.notifier).createBotFromForm(fields);

    ref.read(snackBarProvider).show('Bot ${bot.name} created!');
  }

  void setBotType(BotTypes botType) {
    state = botType;
  }
}
