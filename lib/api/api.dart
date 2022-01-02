library api;

import 'dart:io';

import 'package:bottino_fortino/modules/settings/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

part 'api.exception.dart';
part 'api_security_level.enum.dart';
part 'api_utils.dart';

part 'spot/spot.dart';
part 'spot/trade/trade.dart';

final apiProvider = Provider<Api>((ref) {
  final settings = ref.watch(settingsProvider);
  final spot = ref.watch(_spotProvider);
  return Api(settings.apiKey, settings.apiSecret, settings.apiUrl, spot);
});

class Api {
  final String apiKey;
  final String apiSecret;
  final String url;
  final Spot spot;

  const Api(this.apiKey, this.apiSecret, this.url, this.spot);
}
