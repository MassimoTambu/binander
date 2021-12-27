part of bot;

class BotConfigField<T> {
  final String publicName;
  final String name;
  final String description;
  late final Type type;
  T? value;
  final T? defaultValue;

  BotConfigField({
    required this.publicName,
    required this.name,
    required this.description,
    required this.value,
    this.defaultValue,
  }) {
    type = T;
  }
}
