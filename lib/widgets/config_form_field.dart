part of widgets;

class ConfigFormField extends StatelessWidget {
  final ConfigField configField;

  const ConfigFormField({
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
      initialValue: configField.value ?? configField.defaultValue?.toString(),
      validator: FormBuilderValidators.compose(
        ConfigFieldUtils.toFormBuilderValidators(
          context,
          configField.validators,
        ),
      ),
    );
  }
}
