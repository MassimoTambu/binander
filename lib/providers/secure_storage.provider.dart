part of providers;

final secureStorageProvider = Provider<SecureStorageProvider>((ref) {
  return SecureStorageProvider();
});

class SecureStorageProvider {
  final _secureStorage = const FlutterSecureStorage();

  Future<String?> read(SecureStorageKey key) {
    return _secureStorage.read(key: key.name);
  }

  Future<Map<String, String>> readAll() {
    return _secureStorage.readAll();
  }

  Future<void> write(SecureStorageKey key, String value) {
    return _secureStorage.write(key: key.name, value: value);
  }

  Future<void> delete(SecureStorageKey key) {
    return _secureStorage.delete(key: key.name);
  }

  Future<void> deleteAll() {
    return _secureStorage.deleteAll();
  }
}
