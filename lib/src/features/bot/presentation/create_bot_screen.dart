import 'package:binander/src/features/bot/domain/bots/bot.dart';
import 'package:binander/src/features/bot/domain/bots/bot_types.dart';
import 'package:binander/src/features/bot/presentation/create_bot_controller.dart';
import 'package:binander/src/features/bot/presentation/create_minimize_losses.dart';
import 'package:binander/src/utils/media_query_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateBotScreen extends ConsumerWidget {
  const CreateBotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createBotNotifier = ref.watch(createBotControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create bot'),
        centerTitle: true,
      ),
      body: FormBuilder(
        key: createBotNotifier.formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Container(
              width: MediaQueryUtils.resizeBy(
                percValue: 80,
                currentSize: MediaQuery.of(context).size.width,
              ),
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  const SelectBotField(),
                  FormBuilderTextField(
                    name: Bot.botNameName,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Bob',
                    ),
                    validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required()],
                    ),
                    onChanged: (value) => createBotNotifier.update(name: value),
                  ),
                  FormBuilderSwitch(
                    name: Bot.testNetName,
                    title: Text(
                      'Run on TestNet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: const Text(
                        'Binance removes orders every start of month'),
                    initialValue: true,
                    onChanged: (value) {
                      createBotNotifier.update(isTestNet: value);
                    },
                  ),
                  const BotConfigContainer(),
                  TextButton(
                    onPressed: () {
                      if (createBotNotifier.formKey.currentState!.validate()) {
                        createBotNotifier.createBot();
                        context.pop();
                      }
                    },
                    child: const Text('Create'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectBotField extends ConsumerWidget {
  const SelectBotField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilderDropdown<BotTypes>(
      name: 'bot_type',
      initialValue: ref.watch(createBotControllerProvider).botTypes,
      items: BotTypes.values.map((BotTypes botType) {
        return DropdownMenuItem(
          value: botType,
          child: Text(botType.name),
        );
      }).toList(),
      onChanged: (BotTypes? newBotType) {
        newBotType ??= BotTypes.minimizeLosses;
        ref
            .read(createBotControllerProvider.notifier)
            .update(botTypes: newBotType);
      },
    );
  }
}

class BotConfigContainer extends ConsumerWidget {
  const BotConfigContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final Widget form;
    switch (ref.watch(createBotControllerProvider).botTypes) {
      case BotTypes.minimizeLosses:
        form = const CreateMinimizeLosses();
        break;
      default:
        form = const CreateMinimizeLosses();
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${ref.watch(createBotControllerProvider).botTypes.name} options',
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleMedium?.fontSize),
          ),
          form,
        ],
      ),
    );
  }
}
