part of providers;

final _secureStorageProvider = Provider<SecureStorageProvider>((ref) {
  return SecureStorageProvider();
});

class SecureStorageProvider {
  final _secureStorage = const FlutterSecureStorage();

  Future<String?> read(StorageKeys key) {
    return _secureStorage.read(key: key.name);
  }

  Future<Map<String, String>> readAll() {
    return _secureStorage.readAll();
  }

  Future<void> write(StorageKeys key, String value) {
    return _secureStorage.write(key: key.name, value: value);
  }

  Future<void> delete(StorageKeys key) {
    return _secureStorage.delete(key: key.name);
  }

  Future<void> deleteAll() {
    return _secureStorage.deleteAll();
  }
}
