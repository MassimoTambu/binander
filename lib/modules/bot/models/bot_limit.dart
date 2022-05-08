import 'package:freezed_annotation/freezed_annotation.dart';

part 'bot_limit.freezed.dart';

@freezed
class BotLimit with _$BotLimit {
  const factory BotLimit(String cause) = _BotLimit;
}
