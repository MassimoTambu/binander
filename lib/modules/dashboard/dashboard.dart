library dashboard_module;

import 'package:bottino_fortino/modules/bot/bot.dart';
import 'package:bottino_fortino/modules/bot/bots/minimize_losses/minimize_losses.dart';
import 'package:bottino_fortino/models/models.dart';
import 'package:bottino_fortino/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bottino_fortino/providers/providers.dart';
import 'package:bottino_fortino/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:bottino_fortino/utils/utils.dart';

part 'pages/dashboard.page.dart';
part 'pages/create_bot.page.dart';
part 'providers/create_bot.provider.dart';
part 'providers/dashboard.provider.dart';
part 'widgets/bot_tile/bot_tile.dart';
part 'widgets/bot_tile/bot_tile_button.dart';
part 'widgets/bot_tile/bot_tile_chips.dart';
part 'widgets/bot_tile/bot_tile_details.dart';
