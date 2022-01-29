library providers;

import 'dart:convert';
import 'dart:io';

import 'package:bottino_fortino/api/api.dart';
import 'package:bottino_fortino/bot/bot.dart';
import 'package:bottino_fortino/bot/bots/minimize_losses/minimize_losses.dart';
import 'package:bottino_fortino/modules/settings/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'secure_storage.provider.dart';
part 'memory_storage.provider.dart';
part 'models/secure_storage_key.dart';
part 'snackbar.provider.dart';
part 'binance_status.provider.dart';
part 'file_storage.provider.dart';
part 'init.provider.dart';
