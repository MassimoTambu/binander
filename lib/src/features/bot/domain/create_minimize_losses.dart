import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:binander/src/features/bot/domain/crypto_symbol.dart';

part 'create_minimize_losses.freezed.dart';

@freezed
class CreateMinimizeLosses with _$CreateMinimizeLosses {
  const factory CreateMinimizeLosses(
    double? currentPrice,
    CryptoSymbol? symbol,
    double? stopSellOrderPrice,
  ) = _CreateMinimizeLosses;
}
