import 'package:bottino_fortino/models/config_field.dart';
import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.config.dart';
import 'package:bottino_fortino/modules/bot/models/bot_types.enum.dart';
import 'package:bottino_fortino/providers/pipeline.provider.dart';
import 'package:bottino_fortino/providers/snackbar.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createBotProvider =
    StateNotifierProvider.autoDispose<CreateBotProvider, CreateBotNotifier>(
        (ref) {
  return CreateBotProvider(ref);
});

class CreateBotProvider extends StateNotifier<CreateBotNotifier> {
  final Ref ref;
  final formKey = GlobalKey<FormBuilderState>();

  CreateBotProvider(this.ref)
      : super(CreateBotNotifier(
          '',
          true,
          BotTypes.minimizeLosses,
          MinimizeLossesConfig().configFields,
        ));

  void createBot() {
    final bot = ref
        .read(pipelineProvider.notifier)
        .createBotFromForm(formKey.currentState!.fields);

    ref.read(snackBarProvider).show('Bot ${bot.name} created!');
  }

  void update({
    String? name,
    bool? isTestNet,
    BotTypes? botTypes,
    Map<String, ConfigField>? configFields,
  }) {
    if (isTestNet != null) {
      formKey.currentState?.fields.entries
          .firstWhere((f) => f.key == MinimizeLossesConfig.symbolName)
          .value
          .setValue(null);
    }
    state = state.copyWith(
        name: name,
        isTestNet: isTestNet,
        botTypes: botTypes,
        configFields: configFields);
  }

  void updateConfigField(String key, dynamic value) {
    if (state.configFields[key]?.value != value) {
      state = state.copyWithKVP(kvp: {key: value});
    }
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
        configFields.update(key, (field) => field..value = value.toString());
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
