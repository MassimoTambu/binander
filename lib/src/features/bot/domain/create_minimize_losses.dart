import 'package:binander/src/models/crypto_symbol.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_minimize_losses.freezed.dart';

@freezed
class CreateMinimizeLosses with _$CreateMinimizeLosses {
  const factory CreateMinimizeLosses(
    double? currentPrice,
    CryptoSymbol? symbol,
    double? stopSellOrderPrice,
  ) = _CreateMinimizeLosses;
}
