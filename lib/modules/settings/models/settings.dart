part of settings_module;

class Settings {
  final ApiConnection pubNetConnection;
  final ApiConnection testNetConnection;
  final ThemeMode themeMode;

  const Settings({
    required this.pubNetConnection,
    required this.testNetConnection,
    required this.themeMode,
  });

  Settings copyWith({
    ApiConnection? pubNetConnection,
    ApiConnection? testNetConnection,
    ThemeMode? themeMode,
  }) {
    return Settings(
      pubNetConnection: pubNetConnection ?? this.pubNetConnection,
      testNetConnection: testNetConnection ?? this.testNetConnection,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
