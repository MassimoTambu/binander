import 'package:bottino_fortino/providers/exchange_info_networks.provider.dart';
import 'package:bottino_fortino/providers/file_storage.provider.dart';
import 'package:bottino_fortino/providers/memory_storage.provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final initProvider = FutureProvider<bool>((ref) async {
  final initMemoryStorage = ref.read(memoryStorageProvider.notifier).init();
  final initFileStorage = ref.read(fileStorageProvider).init();

  await Future.wait([initMemoryStorage, initFileStorage]);

  // Find network info AFTER reading Api Keys
  ref.read(exchangeInfoNetworksProvider);

  return true;
});
