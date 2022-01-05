part of providers;

class SecureStorageKey {
  final String name;

  const SecureStorageKey(this.name);

  factory SecureStorageKey.themeMode() {
    return const SecureStorageKey('theme_mode');
  }

  factory SecureStorageKey.apiUrl() {
    return const SecureStorageKey('api_url');
  }

  factory SecureStorageKey.apiKey() {
    return const SecureStorageKey('api_key');
  }

  factory SecureStorageKey.apiSecret() {
    return const SecureStorageKey('api_secret');
  }
}
