part of bot;

class ConfigField<T> {
  final String publicName;
  final String name;
  final String description;
  T? value;
  final T? defaultValue;
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
