enum SecureStorageKeys {
  themeMode('theme_mode'),
  pubNetApiKey('pub_net_api_key'),
  pubNetApiSecret('pub_net_api_secret'),
  testNetApiKey('test_net_api_key'),
  testNetApiSecret('test_net_api_secret');

  const SecureStorageKeys(this.name);

  final String name;
}
