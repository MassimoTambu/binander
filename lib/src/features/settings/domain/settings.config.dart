import 'package:binander/src/features/settings/domain/api_connection.dart';
import 'package:binander/src/models/config_field.dart';
import 'package:binander/src/models/interfaces/config.dart';

class SettingsConfig implements Config {
  ApiConnection pubNetConnection;
  ApiConnection testNetConnection;

  SettingsConfig.create({
    required this.pubNetConnection,
    required this.testNetConnection,
  }) {
    // PubNet
    configFields[pubNetApiKeyName]!.value = pubNetConnection.apiKey;
    configFields[pubNetApiSecretName]!.value = pubNetConnection.apiSecret;
    configFields[pubNetUrlName]!.value = pubNetConnection.url;
    // TestNet
    configFields[testNetApiKeyName]!.value = testNetConnection.apiKey;
    configFields[testNetApiSecretName]!.value = testNetConnection.apiSecret;
    configFields[testNetUrlName]!.value = testNetConnection.url;
  }

  @override
  final Map<String, ConfigField> configFields = {
    // PubNet
    pubNetApiKeyName: ConfigField(
      name: pubNetApiKeyName,
      publicName: apiKeyPublicName,
      description: apiKeyDescription,
    ),
    pubNetApiSecretName: ConfigField(
      name: pubNetApiSecretName,
      publicName: apiSecretPublicName,
      description: apiSecretDescription,
    ),
    pubNetUrlName: ConfigField(
      name: pubNetUrlName,
      publicName: apiUrlPublicName,
      description: apiUrlDescription,
    ),
    // TestNet
    testNetApiKeyName: ConfigField(
      name: testNetApiKeyName,
      publicName: apiKeyPublicName,
      description: apiKeyDescription,
    ),
    testNetApiSecretName: ConfigField(
      name: testNetApiSecretName,
      publicName: apiSecretPublicName,
      description: apiSecretDescription,
    ),
    testNetUrlName: ConfigField(
      name: testNetUrlName,
      publicName: apiUrlPublicName,
      description: apiUrlDescription,
    ),
  };

  // Data
  static const String pubNetApiKeyName = 'pub_net_api_key';
  static const String testNetApiKeyName = 'test_net_api_key';
  static const String apiKeyPublicName = 'Api key';
  static const String apiKeyDescription = '';
  static const String pubNetApiSecretName = 'pub_net_api_secret';
  static const String testNetApiSecretName = 'test_net_api_secret';
  static const String apiSecretPublicName = 'Api secret';
  static const String apiSecretDescription = '';
  static const String pubNetUrlName = 'pub_net_url';
  static const String testNetUrlName = 'test_net_url';
  static const String apiUrlPublicName = 'Url';
  static const String apiUrlDescription = '';
}
