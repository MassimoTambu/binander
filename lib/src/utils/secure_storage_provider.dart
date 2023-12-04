import 'package:binander/src/models/secure_storage_key.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage_provider.g.dart';

class SecureStorage {
  // TODO FOR ANDROID https://pub.dev/packages/flutter_secure_storage
  // encryptedSharedPreferences
  const SecureStorage();

  final _secureStorage = const FlutterSecureStorage();

  Future<String?> read(SecureStorageKeys key) {
    return _secureStorage.read(key: key.name);
  }

  Future<Map<String, String>> readAll() {
    return _secureStorage.readAll();
  }

  Future<void> write(SecureStorageKeys key, String value) {
    return _secureStorage.write(key: key.name, value: value);
  }

  Future<void> delete(SecureStorageKeys key) {
    return _secureStorage.delete(key: key.name);
  }

  Future<void> deleteAll() {
    return _secureStorage.deleteAll();
  }
}

@Riverpod(keepAlive: true)
SecureStorage secureStorage(SecureStorageRef ref) => const SecureStorage();

@Riverpod(keepAlive: true)
Future<Map<String, String>> secureStorageReadAllFuture(
        SecureStorageReadAllFutureRef ref) =>
    ref.watch(secureStorageProvider).readAll();
