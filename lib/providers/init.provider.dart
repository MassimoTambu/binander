part of providers;

final initProvider = FutureProvider<bool>((ref) async {
  final initMemoryStorage = ref.read(memoryStorageProvider.notifier).init();
  final initFileStorage = ref.read(fileStorageProvider).init();

  await Future.wait([initMemoryStorage, initFileStorage]);

  return true;
});
