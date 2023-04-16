import 'dart:async';

import 'package:binander/src/utils/file_storage_provider.dart';
import 'package:binander/src/utils/memory_storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'init_provider.g.dart';

@riverpod
Future<bool> init(InitRef ref) async {
  final completer = Completer<Map<String, dynamic>>();
  ref
      .read(fileStorageProvider.future)
      .then(completer.complete)
      .onError(completer.completeError);

  final memoryStorageSubscription =
      ref.listen<Map<String, String>>(memoryStorageProvider, (previous, next) {
    //TODO remove
    print(previous);
    print(next);
    if (completer.isCompleted && !next.containsKey('loading')) {
      ref.state = const AsyncData(true);
    }
  });

  ref.listenSelf((_, next) {
    next.whenData((value) {
      if (value) {
        memoryStorageSubscription.close();
      }
    });
  });

  return false;
}
