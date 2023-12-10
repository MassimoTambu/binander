import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/bot/domain/crypto_symbol.dart';
import 'package:binander/src/features/settings/domain/api_connection.dart';
import 'package:binander/src/features/settings/domain/secure_storage_key.dart';
import 'package:binander/src/features/settings/domain/settings.dart';
import 'package:binander/src/features/settings/presentation/settings_storage_provider.dart';
import 'package:binander/src/utils/secure_storage_provider.dart';

class MockSecureStorage extends Mock implements SecureStorage {
  @override
  Future<void> write(SecureStorageKeys key, value) async {
    return Future.value();
  }
}

class MockSettingsStorage extends AutoDisposeNotifier<Settings>
    with Mock
    implements SettingsStorage {
  @override
  Settings build() {
    return const Settings(
        pubNetConnection: fakeApiConnection,
        testNetConnection: fakeApiConnection,
        themeMode: ThemeMode.dark);
  }

  static const fakeApiConnection =
      ApiConnection(url: 'fake_url', apiSecret: 'secret', apiKey: 'key');
}

class MockBinanceApi extends Mock implements BinanceApi {}

class MockSpot extends Mock implements Spot {}

class MockMarket extends Mock implements Market {}

class MockTrade extends Mock implements Trade {}

class FakeCryptoSimbol extends Fake implements CryptoSymbol {}
