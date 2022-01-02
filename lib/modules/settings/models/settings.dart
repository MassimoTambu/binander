part of settings_module;

class Settings {
  final String apiKey;
  final String apiSecret;
  final String apiUrl;
  final ThemeMode themeMode;

  const Settings({
    required this.apiKey,
    required this.apiSecret,
    required this.apiUrl,
    required this.themeMode,
  });

  Settings copyWith({
    String? apiKey,
    String? apiSecret,
    String? apiUrl,
    ThemeMode? themeMode,
  }) {
    return Settings(
      apiKey: apiKey ?? this.apiKey,
      apiSecret: apiSecret ?? this.apiSecret,
      apiUrl: apiUrl ?? this.apiUrl,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
