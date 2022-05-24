import 'package:bottino_fortino/api/api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_info_networks.freezed.dart';
part 'exchange_info_networks.g.dart';

@freezed
class ExchangeInfoNetworks with _$ExchangeInfoNetworks {
  const factory ExchangeInfoNetworks({
    required ExchangeInfo pubNet,
    required ExchangeInfo testNet,
  }) = _ExchangeInfoNetworks;

  factory ExchangeInfoNetworks.fromJson(Map<String, dynamic> json) =>
      _$ExchangeInfoNetworksFromJson(json);
}
