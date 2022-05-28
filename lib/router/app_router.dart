import 'package:auto_route/auto_route.dart';
import 'package:binander/api/api.dart';
import 'package:binander/modules/bot/models/run_orders.dart';
import 'package:binander/modules/dashboard/pages/create_bot.page.dart';
import 'package:binander/modules/dashboard/pages/dashboard.page.dart';
import 'package:binander/modules/dashboard/pages/order_detail.page.dart';
import 'package:binander/modules/dashboard/pages/run_order_history.page.dart';
import 'package:binander/modules/settings/pages/binance_api_settings.page.dart';
import 'package:binander/modules/settings/pages/settings.page.dart';
import 'package:flutter/material.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: DashboardPage, initial: true),
    AutoRoute(page: CreateBotPage),
    AutoRoute(page: OrderDetailPage),
    AutoRoute(page: RunOrderHistoryPage),
    AutoRoute(page: SettingsPage),
    AutoRoute(page: BinanceApiSettingsPage),
  ],
)
class AppRouter extends _$AppRouter {}
