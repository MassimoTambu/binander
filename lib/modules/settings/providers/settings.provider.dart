part of settings_module;

final settingsProvider =
    StateNotifierProvider<SettingsProvider, Settings>((ref) {
  return SettingsProvider(ref);
});

class SettingsProvider extends StateNotifier<Settings> {
  final Ref ref;
  static const defaultThemeMode = ThemeMode.dark;
  static const defaultApiUrl = 'https://api.binance.com';

  SettingsProvider(this.ref) : super(_init(ref));

  void updateApiKey(String apiKey) {
    state = state.copyWith(apiKey: apiKey);

    ref.read(memoryStorageProvider.notifier).write(StorageKeys.apiKey, apiKey);
  }

  void updateApiSecret(String apiSecret) {
    state = state.copyWith(apiSecret: apiSecret);

    ref
        .read(memoryStorageProvider.notifier)
        .write(StorageKeys.apiSecret, apiSecret);
  }

  void updateApiUrl(String apiUrl) {
    state = state.copyWith(apiUrl: apiUrl);

    ref.read(memoryStorageProvider.notifier).write(StorageKeys.apiUrl, apiUrl);
  }

  void updateThemeMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);

    ref
        .read(memoryStorageProvider.notifier)
        .write(StorageKeys.themeMode, themeMode.name);
  }

  void updateFromForm({
    required String apiKey,
    required String apiSecret,
    required String apiUrl,
  }) {
    state = state.copyWith(
      apiKey: apiKey,
      apiSecret: apiSecret,
      apiUrl: apiUrl,
    );
  }

  static Settings _init(Ref ref) {
    return Settings(
      apiKey: ref.read(memoryStorageProvider)[StorageKeys.apiKey] ?? '',
      apiSecret: ref.read(memoryStorageProvider)[StorageKeys.apiSecret] ?? '',
      apiUrl: _setDefaultApiUrl(ref),
      themeMode: _setDefaultThemeMode(ref),
    );
  }

  static ThemeMode _setDefaultThemeMode(Ref ref) {
    return ThemeMode.values.firstWhere(
        (key) =>
            key.name == ref.read(memoryStorageProvider)[StorageKeys.themeMode],
        orElse: () {
      ref
          .read(memoryStorageProvider.notifier)
          .write(StorageKeys.themeMode, defaultThemeMode.name);
      return defaultThemeMode;
    });
  }

  static String _setDefaultApiUrl(Ref ref) {
    var apiUrl = ref.read(memoryStorageProvider)[StorageKeys.apiUrl];

    if (apiUrl == null || apiUrl.isEmpty) {
      ref
          .read(memoryStorageProvider.notifier)
          .write(StorageKeys.apiUrl, defaultApiUrl);

      apiUrl = defaultApiUrl;
    }

    return apiUrl;
  }
}
