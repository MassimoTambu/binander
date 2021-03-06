class SecureStorageKey {
  final String name;

  const SecureStorageKey(this.name);

  factory SecureStorageKey.themeMode() {
    return const SecureStorageKey('theme_mode');
  }

  factory SecureStorageKey.pubNetApiKey() {
    return const SecureStorageKey('pub_net_api_key');
  }

  factory SecureStorageKey.pubNetApiSecret() {
    return const SecureStorageKey('pub_net_api_secret');
  }

  factory SecureStorageKey.testNetApiKey() {
    return const SecureStorageKey('test_net_api_key');
  }

  factory SecureStorageKey.testNetApiSecret() {
    return const SecureStorageKey('test_net_api_secret');
  }
}
