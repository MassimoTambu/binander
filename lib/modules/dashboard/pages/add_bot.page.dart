part of dashboard_module;

class AddBotPage extends StatelessWidget {
  AddBotPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  void onCreateBot(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context
          .read<AddBotModel>()
          .createBot(context, _formKey.currentState!.fields);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add bot'),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<AddBotModel>(
        create: (context) => AddBotModel(),
        builder: (context, child) => FormBuilder(
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
                      name: 'bot_name',
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Bob',
                      ),
                      validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)],
                      ),
                    ),
                    const BotConfigContainer(),
                    TextButton(
                      onPressed: () => onCreateBot(context),
                      child: const Text('Create'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectBotField extends StatelessWidget {
  const SelectBotField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      name: 'bot_type',
      initialValue: context.read<AddBotModel>().selectedBotType,
      items: BotTypes.values.map((BotTypes botType) {
        return DropdownMenuItem<BotTypes>(
          value: botType,
          child: Text(botType.name),
        );
      }).toList(),
      onChanged: (BotTypes? newBotType) {
        newBotType ??= BotTypes.minimizeLosses;
        context.read<AddBotModel>().selectedBotType = newBotType;
      },
    );
  }
}

class BotConfigContainer extends StatelessWidget {
  const BotConfigContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final Map<String, ConfigField> configFields;
    switch (context.watch<AddBotModel>().selectedBotType) {
      case BotTypes.minimizeLosses:
        configFields = MinimizeLossesConfig.configFields;
        break;
      default:
        configFields = MinimizeLossesConfig.configFields;
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.read<AddBotModel>().selectedBotType.name + ' options',
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.subtitle1?.fontSize),
          ),
          ...configFields.entries
              .map((e) => BotConfigFormField(configField: e.value)),
        ],
      ),
    );
  }
}

class BotConfigFormField extends StatelessWidget {
  final ConfigField configField;

  const BotConfigFormField({
    Key? key,
    required this.configField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: configField.name,
      decoration: InputDecoration(
        label: Tooltip(
          message: configField.description,
          child: Text(configField.publicName),
        ),
      ),
      initialValue: configField.defaultValue?.toString(),
      validator: FormBuilderValidators.compose(
        ConfigFieldUtils.toFormBuilderValidators(
          context,
          configField.validators,
        ),
      ),
    );
  }
}
