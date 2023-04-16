import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_minimize_losses_params.freezed.dart';

@freezed
class CreateMinimizeLossesParams with _$CreateMinimizeLossesParams {
  const factory CreateMinimizeLossesParams(
    bool isTestNet,
    String? percentageSellOrder,
    String? symbol,
  ) = _CreateMinimizeLossesParams;
}
