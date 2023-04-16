import 'package:binander/src/models/secure_storage_key.dart';
import 'package:binander/src/utils/secure_storage_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memory_storage_provider.g.dart';

@Riverpod(keepAlive: true)
class MemoryStorage extends _$MemoryStorage {
  @override
  Map<String, String> build() {
    debugPrint('init memoryStorage');

    ref
        .watch(secureStorageReadAllFutureProvider)
        .whenData((data) => state = data);

    return {'loading': 'true'};
  }

  String? read(SecureStorageKeys key) => state[key.name];

  Map<String, String> readAll() => state;

  void write(SecureStorageKeys key, String value) {
    ref.watch(secureStorageProvider).write(key, value);
    state[key.name] = value;
  }

  String? delete(SecureStorageKeys key) {
    ref.watch(secureStorageProvider).delete(key);
    return state.remove(key);
  }

  void deleteAll() {
    ref.watch(secureStorageProvider).deleteAll();
    state = {};
  }
}
