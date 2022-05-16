import 'package:bottino_fortino/models/enums/config_field_validators_types.enum.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ConfigFieldUtils {
  static List<String? Function(String?)> toFormBuilderValidators(
      List<ConfigFieldValidatorsTypes> configFieldValidatorsTypes) {
    return configFieldValidatorsTypes
        .map<String? Function(String?)>((validatorType) {
      switch (validatorType) {
        case ConfigFieldValidatorsTypes.required:
          return FormBuilderValidators.required();
        case ConfigFieldValidatorsTypes.int:
          return FormBuilderValidators.integer();
        case ConfigFieldValidatorsTypes.double:
          return FormBuilderValidators.numeric();
        case ConfigFieldValidatorsTypes.positiveNumbers:
          return FormBuilderValidators.min(0);
        case ConfigFieldValidatorsTypes.min1:
          return FormBuilderValidators.min(1);
        default:
      }
      throw Exception(
          'ConfigFieldValidatorsTypes not implemented: $validatorType');
    }).toList();
  }
}
