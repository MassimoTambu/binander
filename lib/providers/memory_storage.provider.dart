part of providers;

final memoryStorageProvider =
    StateNotifierProvider<MemoryStorageProvider, Map<String, String>>((ref) {
  return MemoryStorageProvider(ref);
});

class MemoryStorageProvider extends StateNotifier<Map<String, String>> {
  final Ref ref;

  MemoryStorageProvider(this.ref) : super({});

  Future<bool> init() async {
    if (kDebugMode) {
      print('init memoryStorage');
    }
    state = await ref.watch(_secureStorageProvider).readAll();

    return true;
  }

  String? read(SecureStorageKey key) {
    return state[key.name];
  }

  Map<String, String> readAll() {
    return state;
  }

  void write(SecureStorageKey key, String value) {
    ref.watch(_secureStorageProvider).write(key, value);
    state[key.name] = value;
  }

  String? delete(SecureStorageKey key) {
    ref.watch(_secureStorageProvider).delete(key);
    return state.remove(key);
  }

  void deleteAll() {
    ref.watch(_secureStorageProvider).deleteAll();
    state = {};
  }
}
