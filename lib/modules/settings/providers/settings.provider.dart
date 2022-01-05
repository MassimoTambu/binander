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

    ref
        .read(memoryStorageProvider.notifier)
        .write(SecureStorageKey.apiKey(), apiKey);
  }

  void updateApiSecret(String apiSecret) {
    state = state.copyWith(apiSecret: apiSecret);

    ref
        .read(memoryStorageProvider.notifier)
        .write(SecureStorageKey.apiSecret(), apiSecret);
  }

  void updateApiUrl(String apiUrl) {
    state = state.copyWith(apiUrl: apiUrl);

    ref
        .read(memoryStorageProvider.notifier)
        .write(SecureStorageKey.apiUrl(), apiUrl);
  }

  void updateThemeMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);

    ref
        .read(memoryStorageProvider.notifier)
        .write(SecureStorageKey.themeMode(), themeMode.name);
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

    ref
        .read(memoryStorageProvider.notifier)
        .write(SecureStorageKey.apiKey(), apiKey);

    ref
        .read(memoryStorageProvider.notifier)
        .write(SecureStorageKey.apiSecret(), apiSecret);

    ref
        .read(memoryStorageProvider.notifier)
        .write(SecureStorageKey.apiUrl(), apiUrl);
  }

  static Settings _init(Ref ref) {
    return Settings(
      apiKey: ref.read(memoryStorageProvider)[SecureStorageKey.apiKey] ?? '',
      apiSecret:
          ref.read(memoryStorageProvider)[SecureStorageKey.apiSecret] ?? '',
      apiUrl: _setDefaultApiUrl(ref),
      themeMode: _setDefaultThemeMode(ref),
    );
  }

  static ThemeMode _setDefaultThemeMode(Ref ref) {
    return ThemeMode.values.firstWhere(
        (key) =>
            key.name ==
            ref.read(memoryStorageProvider)[SecureStorageKey.themeMode],
        orElse: () {
      ref
          .read(memoryStorageProvider.notifier)
          .write(SecureStorageKey.themeMode(), defaultThemeMode.name);
      return defaultThemeMode;
    });
  }

  static String _setDefaultApiUrl(Ref ref) {
    var apiUrl = ref.read(memoryStorageProvider)[SecureStorageKey.apiUrl];

    if (apiUrl == null || apiUrl.isEmpty) {
      ref
          .read(memoryStorageProvider.notifier)
          .write(SecureStorageKey.apiUrl(), defaultApiUrl);

      apiUrl = defaultApiUrl;
    }

    return apiUrl;
  }
}
