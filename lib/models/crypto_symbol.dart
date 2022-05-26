import 'package:freezed_annotation/freezed_annotation.dart';

part 'crypto_symbol.freezed.dart';
part 'crypto_symbol.g.dart';

@freezed
class CryptoSymbol with _$CryptoSymbol {
  const CryptoSymbol._();

  const factory CryptoSymbol(String symbol) = _CryptoSymbol;

  /// Get the crypto asset to the left side
  String get baseAsset {
    final end = symbol.indexOf('-');
    return symbol.substring(0, end == -1 ? null : end);
  }

  /// Get the crypto asset to the right side
  String get quoteAsset {
    return symbol.substring(symbol.indexOf('-') + 1);
  }

  @override
  String toString() {
    return symbol.replaceAll('-', '');
  }

  factory CryptoSymbol.fromJson(Map<String, dynamic> json) =>
      _$CryptoSymbolFromJson(json);
}
