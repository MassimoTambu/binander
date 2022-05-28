import 'package:binander/models/config_field.dart';

abstract class Config {
  final Map<String, ConfigField> configFields;

  const Config({required this.configFields});
}
