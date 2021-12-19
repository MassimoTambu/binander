part of services;

class SecureStorageService {
  static final _singleton = SecureStorageService._internal();
  final _secureStorage = const FlutterSecureStorage();

  factory SecureStorageService() {
    return _singleton;
  }

  SecureStorageService._internal();

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
