import 'package:auto_route/auto_route.dart';
import 'package:binander/modules/bot/models/bot.dart';
import 'package:binander/modules/bot/models/bot_types.enum.dart';
import 'package:binander/modules/bot/widgets/create_minimize_losses.dart';
import 'package:binander/modules/dashboard/providers/create_bot.provider.dart';
import 'package:binander/utils/media_query.utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CreateBotPage extends ConsumerWidget {
  const CreateBotPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createBotNotifier = ref.watch(createBotProvider.notifier);
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
                      style: Theme.of(context).textTheme.subtitle1,
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
                        ref.read(createBotProvider.notifier).createBot();
                        context.router.navigateBack();
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
  const SelectBotField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilderDropdown(
      name: 'bot_type',
      initialValue: ref.read(createBotProvider).botTypes,
      items: BotTypes.values.map((BotTypes botType) {
        return DropdownMenuItem<BotTypes>(
          value: botType,
          child: Text(botType.name),
        );
      }).toList(),
      onChanged: (BotTypes? newBotType) {
        newBotType ??= BotTypes.minimizeLosses;
        ref.read(createBotProvider.notifier).update(botTypes: newBotType);
      },
    );
  }
}

class BotConfigContainer extends ConsumerWidget {
  const BotConfigContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final Widget form;
    switch (ref.watch(createBotProvider).botTypes) {
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
            '${ref.watch(createBotProvider).botTypes.name} options',
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.subtitle1?.fontSize),
          ),
          form,
        ],
      ),
    );
  }
}
