library api;

import 'dart:io';

import 'package:bottino_fortino/services/services.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

part 'api.exception.dart';
part 'api_security_level.enum.dart';
part 'api_utils.dart';

part 'spot/spot.dart';
part 'spot/trade/trade.dart';

class Api {
  static final Api _singleton = Api._internal();

  late final String url;
  late final String apiKey;
  late final String apiSecret;

  final spot = Spot();

  factory Api(
      {required String url,
      required String apiKey,
      required String apiSecret}) {
    return _singleton;
  }

  Api._internal();
}
