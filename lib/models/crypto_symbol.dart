import 'package:freezed_annotation/freezed_annotation.dart';

part 'crypto_symbol.freezed.dart';

@freezed
class CryptoSymbol with _$CryptoSymbol {
  const CryptoSymbol._();

  const factory CryptoSymbol(String symbol) = _CryptoSymbol;

  String get leftPair {
    return symbol.substring(0, symbol.indexOf('-'));
  }

  String get rightPair {
    return symbol.substring(symbol.indexOf('-') + 1);
  }

  @override
  String toString() {
    return symbol.replaceAll('-', '');
  }

  factory CryptoSymbol.fromJson(Map<String, dynamic> json) =>
      _$CryptoSymbolFromJson(json);
}
