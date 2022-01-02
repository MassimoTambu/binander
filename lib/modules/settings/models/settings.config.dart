// ignore_for_file: prefer_initializing_formals

part of settings_module;

class SettingsConfig implements Config {
  String? apiKey;
  String? apiSecret;
  String? apiUrl;

  SettingsConfig();

  SettingsConfig.create({
    required String apiKey,
    required String apiSecret,
    required String apiUrl,
  }) {
    this.apiKey = apiKey;
    this.apiSecret = apiSecret;
    this.apiUrl = apiUrl;
    configFields[apiKeyName]!.value = apiKey;
    configFields[apiSecretName]!.value = apiSecret;
    configFields[apiUrlName]!.value = apiUrl;
  }

  @override
  final Map<String, ConfigField> configFields = {
    apiKeyName: ConfigField(
      name: apiKeyName,
      publicName: apiKeyPublicName,
      description: apiKeyDescription,
      value: null,
      configFieldTypes: ConfigFieldTypes.textField,
      validators: [
        ConfigFieldValidatorsTypes.required,
      ],
    ),
    apiSecretName: ConfigField(
      name: apiSecretName,
      publicName: apiSecretPublicName,
      description: apiSecretDescription,
      value: null,
      configFieldTypes: ConfigFieldTypes.textField,
      validators: [
        ConfigFieldValidatorsTypes.required,
      ],
    ),
    apiUrlName: ConfigField(
      name: apiUrlName,
      publicName: apiUrlPublicName,
      description: apiUrlDescription,
      value: null,
      configFieldTypes: ConfigFieldTypes.textField,
      validators: [
        ConfigFieldValidatorsTypes.required,
      ],
    ),
  };

  // Data
  static const String apiKeyName = 'api_key';
  static const String apiKeyPublicName = 'Api key';
  static const String apiKeyDescription = '';
  static const String apiSecretName = 'api_secret';
  static const String apiSecretPublicName = 'Api secret';
  static const String apiSecretDescription = '';
  static const String apiUrlName = 'api_url';
  static const String apiUrlPublicName = 'Api url';
  static const String apiUrlDescription = '';
}
