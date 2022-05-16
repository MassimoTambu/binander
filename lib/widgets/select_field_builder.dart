import 'package:bottino_fortino/models/select_field.dart';
import 'package:bottino_fortino/utils/config_field.utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

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
              value: c,
              child: Text(c),
            ),
          )
          .toList(),
      validator: FormBuilderValidators.compose(
        ConfigFieldUtils.toFormBuilderValidators(configField.validators),
      ),
      enabled: enabled,
    );
  }
}
