part of models;

abstract class Config {
  final Map<String, ConfigField> configFields;

  const Config({required this.configFields});
}
