library bot;

import 'dart:async';

import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'models/bot.dart';
part 'models/interfaces/pipeline.interface.dart';
part 'models/interfaces/pipeline_data.interface.dart';
part 'models/orders_history.dart';
part 'models/bot_types.enum.dart';
part 'models/bot_phases.enum.dart';
part 'models/bot_status.dart';
part 'models/bot_limit.dart';
part 'models/order_pair.dart';
part 'bot.freezed.dart';
part 'bot.g.dart';
