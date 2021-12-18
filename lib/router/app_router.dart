library app_router;

import 'package:auto_route/auto_route.dart';
import 'package:bottino_fortino/modules/dashboard/dashboard.dart';
import 'package:bottino_fortino/modules/settings/settings.dart';
import 'package:flutter/material.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: DashboardPage, initial: true),
    AutoRoute(page: SettingsPage),
  ],
)
class AppRouter extends _$AppRouter {}
