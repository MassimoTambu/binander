part of dashboard_module;

class AddBotPage extends StatelessWidget {
  AddBotPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  void onCreate(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Process data.
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
        child: Form(
          key: _formKey,
          child: Center(
            child: SizedBox(
              width: MediaQueryUtils.resizeBy(
                percValue: 80,
                currentSize: MediaQuery.of(context).size.width,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const SelectBotField(),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Bob',
                    ),
                    validator: (value) =>
                        ValidatorUtils.required(value, name: 'Name'),
                  ),
                  const BotConfigContainer(),
                  TextButton(
                    onPressed: () => onCreate(context),
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

class SelectBotField extends StatelessWidget {
  const SelectBotField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<BotTypes>(
      builder: (FormFieldState<BotTypes> state) {
        return InputDecorator(
          decoration: const InputDecoration(),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<BotTypes>(
              value: context.watch<AddBotModel>().selectedBotType,
              isDense: true,
              onChanged: (BotTypes? newBotType) {
                newBotType ??= BotTypes.minimizeLosses;
                context.read<AddBotModel>().selectedBotType = newBotType;
                state.didChange(newBotType);
              },
              items: BotTypes.values.map((BotTypes botType) {
                return DropdownMenuItem<BotTypes>(
                  value: botType,
                  child: Text(botType.name),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class BotConfigContainer extends StatelessWidget {
  const BotConfigContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final Map<String, BotConfigField> configFields;
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
  final BotConfigField configField;

  const BotConfigFormField({
    Key? key,
    required this.configField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: Tooltip(
          message: configField.description,
          child: Text(configField.publicName),
        ),
      ),
      initialValue: configField.defaultValue?.toString(),
      validator: (value) => ValidatorUtils.required(value),
    );
  }
}
