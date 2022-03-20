part of settings_module;

final settingsProvider =
    StateNotifierProvider<SettingsProvider, Settings>((ref) {
  return SettingsProvider(ref);
});

class SettingsProvider extends StateNotifier<Settings> {
  final Ref ref;
  static const defaultThemeMode = ThemeMode.dark;
  static const pubNetUrl = 'https://api.binance.com';
  static const testNetUrl = 'https://testnet.binance.vision';

  SettingsProvider(this.ref) : super(_init(ref));

  void updateThemeMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);

    ref
        .read(memoryStorageProvider.notifier)
        .write(SecureStorageKey.themeMode(), themeMode.name);
  }

  void updateFromForm({
    required String pubNetApiKey,
    required String pubNetApiSecret,
    required String? testNetApiKey,
    required String? testNetApiSecret,
  }) {
    state = state.copyWith(
      pubNetConnection: ApiConnection(
        url: pubNetUrl,
        apiKey: pubNetApiKey,
        apiSecret: pubNetApiSecret,
      ),
      testNetConnection: ApiConnection(
        url: testNetUrl,
        apiKey: testNetApiKey ?? '',
        apiSecret: testNetApiSecret ?? '',
      ),
    );

    ref
        .read(memoryStorageProvider.notifier)
        .write(SecureStorageKey.pubNetApiKey(), pubNetApiKey);

    ref
        .read(memoryStorageProvider.notifier)
        .write(SecureStorageKey.pubNetApiSecret(), pubNetApiSecret);

    if (testNetApiKey != null) {
      ref
          .read(memoryStorageProvider.notifier)
          .write(SecureStorageKey.testNetApiKey(), testNetApiKey);
    }

    if (testNetApiSecret != null) {
      ref
          .read(memoryStorageProvider.notifier)
          .write(SecureStorageKey.testNetApiSecret(), testNetApiSecret);
    }
  }

  static Settings _init(Ref ref) {
    final data = ref.read(memoryStorageProvider);

    final pubNetConnection = ApiConnection(
        url: pubNetUrl,
        apiKey: data[SecureStorageKey.pubNetApiKey().name] ?? '',
        apiSecret: data[SecureStorageKey.pubNetApiSecret().name] ?? '');
    final testNetConnection = ApiConnection(
        url: testNetUrl,
        apiKey: data[SecureStorageKey.testNetApiKey().name] ?? '',
        apiSecret: data[SecureStorageKey.testNetApiSecret().name] ?? '');
    return Settings(
      pubNetConnection: pubNetConnection,
      testNetConnection: testNetConnection,
      themeMode: _setDefaultThemeMode(ref),
    );
  }

  static ThemeMode _setDefaultThemeMode(Ref ref) {
    final themeMode = SecureStorageKey.themeMode();
    final memory = ref.read(memoryStorageProvider);

    final selectedThemeMode = ThemeMode.values
        .firstWhere((key) => key.name == memory[themeMode.name], orElse: () {
      ref
          .read(memoryStorageProvider.notifier)
          .write(themeMode, defaultThemeMode.name);
      return defaultThemeMode;
    });

    return selectedThemeMode;
  }
}
