import 'package:bottino_fortino/models/config_field.dart';
import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.config.dart';
import 'package:bottino_fortino/modules/bot/models/bot_types.enum.dart';
import 'package:bottino_fortino/providers/pipeline.provider.dart';
import 'package:bottino_fortino/providers/snackbar.provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createBotProvider =
    StateNotifierProvider<CreateBotProvider, CreateBotNotifier>((ref) {
  return CreateBotProvider(ref);
});

class CreateBotProvider extends StateNotifier<CreateBotNotifier> {
  final Ref ref;

  CreateBotProvider(this.ref)
      : super(CreateBotNotifier(
            BotTypes.minimizeLosses, MinimizeLossesConfig().configFields));

  void createBot(
      Map<String, FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>>
          fields) {
    final bot = ref.read(pipelineProvider.notifier).createBotFromForm(fields);

    ref.read(snackBarProvider).show('Bot ${bot.name} created!');
  }

  void update({BotTypes? botTypes, Map<String, ConfigField>? configFields}) {
    state = state.copyWith(botTypes, configFields);
  }

  void updateConfigField(String key, dynamic value) {
    state = state.copyWith(null, {key: value});
  }
}

class CreateBotNotifier {
  final BotTypes botTypes;
  final Map<String, ConfigField> configFields;

  const CreateBotNotifier(this.botTypes, this.configFields);

  CreateBotNotifier copyWith(
      BotTypes? botTypes, Map<String, ConfigField>? configFields) {
    if (configFields != null) {
      this.configFields.forEach((key, value) {
        configFields.putIfAbsent(key, () => value);
      });
    }

    return CreateBotNotifier(
        botTypes ?? this.botTypes, configFields ?? this.configFields);
  }
}
