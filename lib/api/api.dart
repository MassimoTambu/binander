library api;

import 'package:bottino_fortino/models/crypto_symbol.dart';
import 'package:bottino_fortino/modules/settings/models/api_connection.dart';
import 'package:bottino_fortino/utils/parse.utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

part 'api.exception.dart';
part 'api_security_level.enum.dart';
part 'api_utils.dart';
part 'api_response.dart';
part 'api_constants.dart';

part 'models/api_key_permission.dart';
part 'models/average_price.dart';
part 'models/system_status.dart';
part 'models/account_and_symbol_permission.enum.dart';
part 'models/symbol_status.enum.dart';
part 'models/time_in_force.enum.dart';
part 'models/rate_limit_types.enum.dart';
part 'models/rate_limit_intervals.enum.dart';

part 'models/oco/oco_status.enum.dart';
part 'models/oco/oco_order_status.enum.dart';
part 'models/account/account_information.dart';
part 'models/account/account_balance.dart';
part 'models/order/order.dart';
part 'models/order/order_new_stop_limit.dart';
part 'models/order/fill.dart';
part 'models/order/order_status.enum.dart';
part 'models/order/order_types.enum.dart';
part 'models/order/order_response_types.enum.dart';
part 'models/order/order_sides.enum.dart';

part 'api.g.dart';
part 'api.freezed.dart';

part 'api.provider.dart';
part 'dio.provider.dart';
part 'spot/spot.provider.dart';
part 'spot/market/market.provider.dart';
part 'spot/trade/trade.provider.dart';
part 'spot/wallet/wallet.provider.dart';
