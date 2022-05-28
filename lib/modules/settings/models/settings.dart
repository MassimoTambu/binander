import 'package:binander/modules/settings/models/api_connection.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';

@freezed
class Settings with _$Settings {
  const factory Settings({
    required ApiConnection pubNetConnection,
    required ApiConnection testNetConnection,
    required ThemeMode themeMode,
  }) = _Settings;
}
