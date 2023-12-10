class ConfigField {
  final String publicName;
  final String name;
  final String description;
  String? value;
  final String? defaultValue;
  final List<String>? items;

  ConfigField({
    required this.publicName,
    required this.name,
    required this.description,
    this.value,
    this.defaultValue,
    this.items,
  });
}
