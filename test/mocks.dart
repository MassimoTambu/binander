import 'package:binander/src/api/api.dart';
import 'package:binander/src/models/crypto_symbol.dart';
import 'package:binander/src/utils/secure_storage_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorage extends Mock implements SecureStorage {}

class MockBinanceApi extends Mock implements BinanceApi {}

class MockSpot extends Mock implements Spot {}

class MockMarket extends Mock implements Market {}

class MockTrade extends Mock implements Trade {}

class FakeCryptoSimbol extends Fake implements CryptoSymbol {}
