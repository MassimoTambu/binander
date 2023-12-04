import 'dart:async';

import 'package:binander/src/utils/file_storage_provider.dart';
import 'package:binander/src/utils/memory_storage_provider.dart';
import 'package:binander/src/utils/secure_storage_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'init_provider.g.dart';

@riverpod
Future<void> init(InitRef ref) async {
  debugPrint('init initProvider');
  final (fileStorage, secureStorageData) = await (
    ref.watch(fileStorageProvider.future),
    ref.watch(secureStorageReadAllFutureProvider.future)
  ).wait;

  ref.watch(memoryStorageProvider.notifier).load(secureStorageData);
}
