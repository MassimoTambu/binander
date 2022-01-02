part of models;

class ConfigFieldUtils {
  static List<String? Function(String?)> toFormBuilderValidators(
      BuildContext context,
      List<ConfigFieldValidatorsTypes> configFieldValidatorsTypes) {
    return configFieldValidatorsTypes
        .map<String? Function(String?)>((validatorType) {
      switch (validatorType) {
        case ConfigFieldValidatorsTypes.required:
          return FormBuilderValidators.required(context);
        case ConfigFieldValidatorsTypes.int:
          return FormBuilderValidators.integer(context);
        case ConfigFieldValidatorsTypes.double:
          return FormBuilderValidators.numeric(context);
        case ConfigFieldValidatorsTypes.positiveNumbers:
          return FormBuilderValidators.min(context, 0);
        default:
      }
      throw Exception(
          'ConfigFieldValidatorsTypes not implemented: $validatorType');
    }).toList();
  }
}
