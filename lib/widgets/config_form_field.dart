part of widgets;

class ConfigFormField extends StatelessWidget {
  final ConfigField configField;
  final bool enabled;

  const ConfigFormField({
    Key? key,
    required this.configField,
    this.enabled = true,
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
        filled: !enabled,
      ),
      initialValue: configField.value ?? configField.defaultValue?.toString(),
      validator: FormBuilderValidators.compose(
        ConfigFieldUtils.toFormBuilderValidators(
          context,
          configField.validators,
        ),
      ),
      enabled: enabled,
    );
  }
}
