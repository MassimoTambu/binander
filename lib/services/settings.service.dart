part of services;

class SettingsService {
  static final _singleton = SettingsService._internal();
  final _memoryStorageService = MemoryStorageService();
  final defaultThemeMode = ThemeMode.dark;

  factory SettingsService() {
    return _singleton;
  }

  SettingsService._internal();

  String get apiUrl {
    return _memoryStorageService.read(StorageKeys.apiUrl) ?? '';
    return 'https://api.binance.com/api/v3';
  }

  set apiUrl(String value) {
    return _memoryStorageService.write(StorageKeys.apiUrl, value);
  }

  String get apiKey {
    return _memoryStorageService.read(StorageKeys.apiKey) ?? '';
    return 'RsFTPmYyt31wlu9Kfc5sUHhGl8m3uyvXdfr5pm2H1egjANuZV5MlXJp6ZzfmJFkd';
  }

  set apiKey(String value) {
    return _memoryStorageService.write(StorageKeys.apiKey, value);
  }

  String get apiSecret {
    return _memoryStorageService.read(StorageKeys.apiSecret) ?? '';
    return 'Pov5KpPI2Hu8Ho3mZaHoUSKYXQbNOEzgqoHDr5mBvBu22yCPd6Wwa2zVWie28evR';
  }

  set apiSecret(String value) {
    return _memoryStorageService.write(StorageKeys.apiSecret, value);
  }

  ThemeMode get themeMode {
    final themeModeStr = _memoryStorageService.read(StorageKeys.themeMode);

    if (themeModeStr == null) return defaultThemeMode;

    return ThemeMode.values.firstWhere((key) => key.name == themeModeStr);
  }

  set themeMode(ThemeMode value) {
    return _memoryStorageService.write(StorageKeys.themeMode, value.name);
  }
}
