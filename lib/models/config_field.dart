import 'package:bottino_fortino/models/enums/config_field_types.enum.dart';
import 'package:bottino_fortino/models/enums/config_field_validators_types.enum.dart';

class ConfigField {
  final String publicName;
  final String name;
  final String description;
  String? value;
  final String? defaultValue;
  final ConfigFieldTypes configFieldTypes;
  final List<ConfigFieldValidatorsTypes> validators;

  ConfigField({
    required this.publicName,
    required this.name,
    required this.description,
    required this.value,
    required this.configFieldTypes,
    required this.validators,
    this.defaultValue,
  });
}
