import 'package:binander/src/features/settings/domain/api_connection.dart';
import 'package:binander/src/features/settings/domain/settings.dart';
import 'package:binander/src/models/secure_storage_key.dart';
import 'package:binander/src/utils/memory_storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@riverpod
class SettingsStorage extends _$SettingsStorage {
  @override
  Future<Settings> build() async {
    final data = ref.read(memoryStorageProvider);

    final pubNetConnection = ApiConnection(
        url: pubNetUrl,
        apiKey: data.requireValue[SecureStorageKeys.pubNetApiKey.name] ?? '',
        apiSecret:
            data.requireValue[SecureStorageKeys.pubNetApiSecret.name] ?? '');
    final testNetConnection = ApiConnection(
        url: testNetUrl,
        apiKey: data.requireValue[SecureStorageKeys.testNetApiKey.name] ?? '',
        apiSecret:
            data.requireValue[SecureStorageKeys.testNetApiSecret.name] ?? '');
    return Settings(
      pubNetConnection: pubNetConnection,
      testNetConnection: testNetConnection,
      themeMode: _setDefaultThemeMode(ref),
    );
  }

  static const defaultThemeMode = ThemeMode.dark;
  static const pubNetUrl = 'https://api.binance.com';
  static const testNetUrl = 'https://testnet.binance.vision';

  void updateThemeMode(ThemeMode themeMode) {
    state = AsyncData(state.requireValue.copyWith(themeMode: themeMode));

    ref
        .read(memoryStorageProvider.notifier)
        .write(SecureStorageKeys.themeMode, themeMode.name);
  }

  void updateFromForm({
    required String? pubNetApiKey,
    required String? pubNetApiSecret,
    required String? testNetApiKey,
    required String? testNetApiSecret,
  }) {
    state = AsyncData(state.requireValue.copyWith(
      pubNetConnection: ApiConnection(
        url: pubNetUrl,
        apiKey: pubNetApiKey ?? '',
        apiSecret: pubNetApiSecret ?? '',
      ),
      testNetConnection: ApiConnection(
        url: testNetUrl,
        apiKey: testNetApiKey ?? '',
        apiSecret: testNetApiSecret ?? '',
      ),
    ));

    if (pubNetApiKey != null && pubNetApiKey.isNotEmpty) {
      ref
          .read(memoryStorageProvider.notifier)
          .write(SecureStorageKeys.pubNetApiKey, pubNetApiKey);
    }

    if (pubNetApiSecret != null && pubNetApiSecret.isNotEmpty) {
      ref
          .read(memoryStorageProvider.notifier)
          .write(SecureStorageKeys.pubNetApiSecret, pubNetApiSecret);
    }

    if (testNetApiKey != null && testNetApiKey.isNotEmpty) {
      ref
          .read(memoryStorageProvider.notifier)
          .write(SecureStorageKeys.testNetApiKey, testNetApiKey);
    }

    if (testNetApiSecret != null && testNetApiSecret.isNotEmpty) {
      ref
          .read(memoryStorageProvider.notifier)
          .write(SecureStorageKeys.testNetApiSecret, testNetApiSecret);
    }
  }

  static ThemeMode _setDefaultThemeMode(Ref ref) {
    const themeMode = SecureStorageKeys.themeMode;
    final memory = ref.read(memoryStorageProvider);

    final selectedThemeMode = ThemeMode.values.firstWhere(
        (key) => key.name == memory.requireValue[themeMode.name], orElse: () {
      ref
          .read(memoryStorageProvider.notifier)
          .write(themeMode, defaultThemeMode.name);
      return defaultThemeMode;
    });

    return selectedThemeMode;
  }
}
