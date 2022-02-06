part of models;

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
