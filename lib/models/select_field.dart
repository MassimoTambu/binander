import 'package:bottino_fortino/models/config_field.dart';
import 'package:bottino_fortino/models/enums/config_field_types.enum.dart';
import 'package:bottino_fortino/models/enums/config_field_validators_types.enum.dart';

class SelectField extends ConfigField {
  final List<String> items;

  SelectField({
    required String publicName,
    required String name,
    required String description,
    required String? value,
    required this.items,
    required ConfigFieldTypes configFieldTypes,
    required List<ConfigFieldValidatorsTypes> validators,
    String? defaultValue,
  }) : super(
          publicName: publicName,
          name: name,
          description: description,
          value: value,
          defaultValue: defaultValue,
          configFieldTypes: configFieldTypes,
          validators: validators,
        );
}
