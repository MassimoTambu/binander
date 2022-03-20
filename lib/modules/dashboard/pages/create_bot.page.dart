part of dashboard_module;

class CreateBotPage extends ConsumerWidget {
  CreateBotPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  void onCreateBot(BuildContext context, WidgetRef ref) {
    if (_formKey.currentState!.validate()) {
      ref
          .read(createBotProvider.notifier)
          .createBot(_formKey.currentState!.fields);
      context.router.navigateBack();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create bot'),
        centerTitle: true,
      ),
      body: FormBuilder(
        key: _formKey,
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
                      [FormBuilderValidators.required(context)],
                    ),
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
                  ),
                  const BotConfigContainer(),
                  TextButton(
                    onPressed: () => onCreateBot(context, ref),
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
      initialValue: ref.read(createBotProvider),
      items: BotTypes.values.map((BotTypes botType) {
        return DropdownMenuItem<BotTypes>(
          value: botType,
          child: Text(botType.name),
        );
      }).toList(),
      onChanged: (BotTypes? newBotType) {
        newBotType ??= BotTypes.minimizeLosses;
        ref.read(createBotProvider.notifier).setBotType(newBotType);
      },
    );
  }
}

class BotConfigContainer extends ConsumerWidget {
  const BotConfigContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final Map<String, ConfigField> configFields;
    switch (ref.watch(createBotProvider)) {
      case BotTypes.minimizeLosses:
        configFields = MinimizeLossesConfig().configFields;
        break;
      default:
        configFields = MinimizeLossesConfig().configFields;
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ref.watch(createBotProvider).name + ' options',
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.subtitle1?.fontSize),
          ),
          ...configFields.entries.map((e) {
            if (e.value is SelectField) {
              return SelectFieldBuilder(configField: e.value as SelectField);
            }
            return ConfigFieldBuilder(configField: e.value);
          }),
        ],
      ),
    );
  }
}
