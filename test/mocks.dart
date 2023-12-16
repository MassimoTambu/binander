import 'package:mocktail/mocktail.dart';

import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/bot/domain/crypto_symbol.dart';
import 'package:binander/src/features/settings/domain/secure_storage_key.dart';
import 'package:binander/src/utils/secure_storage_provider.dart';

class MockSecureStorage extends Mock implements SecureStorage {
  @override
  Future<void> write(SecureStorageKeys key, value) async {
    return Future.value();
  }
}

class MockBinanceApi extends Mock implements BinanceApi {}

class MockSpot extends Mock implements Spot {}

class MockMarket extends Mock implements Market {}

class MockTrade extends Mock implements Trade {}

class FakeCryptoSimbol extends Fake implements CryptoSymbol {}
