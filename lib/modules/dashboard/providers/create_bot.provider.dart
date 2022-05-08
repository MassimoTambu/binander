import 'package:bottino_fortino/modules/bot/models/bot_types.enum.dart';
import 'package:bottino_fortino/providers/pipeline.provider.dart';
import 'package:bottino_fortino/providers/snackbar.provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final bot = ref.read(pipelineProvider.notifier).createBotFromForm(fields);

    ref.read(snackBarProvider).show('Bot ${bot.name} created!');
  }

  void setBotType(BotTypes botType) {
    state = botType;
  }
}
