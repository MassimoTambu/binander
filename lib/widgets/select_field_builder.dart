part of widgets;

class SelectFieldBuilder extends StatelessWidget {
  final SelectField configField;
  final bool enabled;

  const SelectFieldBuilder({
    Key? key,
    required this.configField,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      name: configField.name,
      decoration: InputDecoration(
        label: Text(configField.publicName),
        helperText: configField.description,
        filled: !enabled,
      ),
      initialValue: configField.value ?? configField.defaultValue?.toString(),
      items: configField.items
          .map(
            (c) => DropdownMenuItem<String>(
              child: Text(c),
              value: c,
            ),
          )
          .toList(),
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
