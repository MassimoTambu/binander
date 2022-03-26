part of settings_module;

@freezed
class Settings with _$Settings {
  const factory Settings({
    required ApiConnection pubNetConnection,
    required ApiConnection testNetConnection,
    required ThemeMode themeMode,
  }) = _Settings;
}
