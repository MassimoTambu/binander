import 'package:binander/src/features/settings/domain/config_field.dart';

abstract class Config {
  final Map<String, ConfigField> configFields;

  const Config({required this.configFields});
}
