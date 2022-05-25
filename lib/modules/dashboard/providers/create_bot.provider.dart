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
          '',
          true,
          BotTypes.minimizeLosses,
          MinimizeLossesConfig().configFields,
        ));

  void createBot(
      Map<String, FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>>
          fields) {
    final bot = ref.read(pipelineProvider.notifier).createBotFromForm(fields);

    ref.read(snackBarProvider).show('Bot ${bot.name} created!');
  }

  void update({
    String? name,
    bool? isTestNet,
    BotTypes? botTypes,
    Map<String, ConfigField>? configFields,
  }) {
    state = state.copyWith(
        name: name,
        isTestNet: isTestNet,
        botTypes: botTypes,
        configFields: configFields);
  }

  void updateConfigField(String key, dynamic value) {
    state = state.copyWithKVP(kvp: {key: value});
  }
}

class CreateBotNotifier {
  final String name;
  final bool isTestNet;
  final BotTypes botTypes;
  final Map<String, ConfigField> configFields;

  const CreateBotNotifier(
      this.name, this.isTestNet, this.botTypes, this.configFields);

  CreateBotNotifier copyWith({
    String? name,
    bool? isTestNet,
    BotTypes? botTypes,
    Map<String, ConfigField>? configFields,
  }) {
    return CreateBotNotifier(
      name ?? this.name,
      isTestNet ?? this.isTestNet,
      botTypes ?? this.botTypes,
      configFields ?? this.configFields,
    );
  }

  CreateBotNotifier copyWithKVP({
    String? name,
    bool? isTestNet,
    BotTypes? botTypes,
    Map<String, dynamic>? kvp,
  }) {
    if (kvp != null) {
      kvp.forEach((key, value) {
        configFields.update(key, (field) => field..value = value);
      });
    }

    return CreateBotNotifier(
      name ?? this.name,
      isTestNet ?? this.isTestNet,
      botTypes ?? this.botTypes,
      configFields,
    );
  }
}
