library providers;

import 'dart:convert';
import 'dart:io';

import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/models/models.dart';
import 'package:bottino_fortino/modules/bot/bot.dart';
import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.dart';
import 'package:bottino_fortino/modules/settings/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

part 'secure_storage.provider.dart';
part 'memory_storage.provider.dart';
part 'snackbar.provider.dart';
part 'binance_account_information.provider.dart';
part 'binance_pub_net_status.provider.dart';
part 'binance_test_net_status.provider.dart';
part 'file_storage.provider.dart';
part 'init.provider.dart';
part 'bot.provider.dart';
