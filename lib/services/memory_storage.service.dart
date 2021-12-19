part of services;

class MemoryStorageService {
  static final _singleton = MemoryStorageService._internal();
  final _secureStorageService = SecureStorageService();
  var _data = <String, String>{};

  factory MemoryStorageService() {
    return _singleton;
  }

  MemoryStorageService._internal();

  Future<bool> init() async {
    print('init');
    _data = await _secureStorageService.readAll();

    return true;
  }

  String? read(StorageKeys key) {
    return _data[key.name];
  }

  Map<String, String> readAll() {
    return _data;
  }

  void write(StorageKeys key, String value) {
    _secureStorageService.write(key, value);
    _data[key.name] = value;
  }

  String? delete(StorageKeys key) {
    _secureStorageService.delete(key);
    return _data.remove(key);
  }

  void deleteAll() {
    _secureStorageService.deleteAll();
    _data = {};
  }
}
