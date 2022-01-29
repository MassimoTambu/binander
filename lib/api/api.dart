library api;

import 'dart:io';

import 'package:bottino_fortino/modules/settings/settings.dart';
import 'package:bottino_fortino/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api.exception.dart';
part 'api_security_level.enum.dart';
part 'api_utils.dart';
part 'api_response.dart';
part 'api_constants.dart';

part 'models/account_and_symbol_permission.enum.dart';
part 'models/symbol_status.enum.dart';
part 'models/time_in_force.enum.dart';
part 'models/rate_limit_types.enum.dart';
part 'models/rate_limit_intervals.enum.dart';

part 'models/oco/oco_status.enum.dart';
part 'models/oco/oco_order_status.enum.dart';
part 'models/account/account_information.dart';
part 'models/order/order.dart';
part 'models/order/order_new.dart';
part 'models/order/order_status.enum.dart';
part 'models/order/order_types.enum.dart';
part 'models/order/order_response_types.enum.dart';
part 'models/order/order_sides.enum.dart';

part 'api.g.dart';

part 'spot/spot.dart';
part 'spot/trade/trade.dart';
part 'spot/wallet/wallet.dart';

final apiProvider = Provider<Api>((ref) {
  final spot = ref.watch(_spotProvider);
  return Api(spot);
});

class Api {
  final Spot spot;

  const Api(this.spot);
}
