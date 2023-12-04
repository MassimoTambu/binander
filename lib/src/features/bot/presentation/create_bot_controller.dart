import 'package:binander/src/features/bot/domain/bots/bot_types.dart';
import 'package:binander/src/features/bot/domain/bots/minimize_losses/minimize_losses_config.dart';
import 'package:binander/src/features/bot/presentation/pipeline_controller.dart';
import 'package:binander/src/models/config_field.dart';
import 'package:binander/src/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_bot_controller.g.dart';

@riverpod
class CreateBotController extends _$CreateBotController {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  CreateBotNotifier build() {
    return CreateBotNotifier(
      '',
      true,
      BotTypes.minimizeLosses,
      MinimizeLossesConfig().configFields,
    );
  }

  void createBot() {
    final bot = ref
        .read(pipelineControllerProvider.notifier)
        .createBotFromForm(formKey.currentState!.fields);

    showSnackBarAction('Bot ${bot.name} created!');
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
