import 'package:binander/api/api.dart';
import 'package:binander/modules/bot/models/run_orders.dart';
import 'package:binander/modules/dashboard/pages/create_bot.page.dart';
import 'package:binander/modules/dashboard/pages/dashboard.page.dart';
import 'package:binander/modules/dashboard/pages/order_detail.page.dart';
import 'package:binander/modules/dashboard/pages/run_order_history.page.dart';
import 'package:binander/modules/settings/pages/binance_api_settings.page.dart';
import 'package:binander/modules/settings/pages/settings.page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  dashboard('dashboard'),
  createBot('create-bot'),
  orderDetails('order-details'),
  runOrderHistory('run-order-history'),
  settings('settings'),
  binanceApiSettings('binance-api-settings');

  const AppRoute(this.name);

  final String name;
}

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// * Missing support for Nested Navigation with GoRouter
// See progress in PR: https://github.com/flutter/packages/pull/2650
final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  debugLogDiagnostics: true,
  routes: [
    // * There is currently an animation bug when using ShellRoute
    // https://github.com/flutter/flutter/issues/113130
    GoRoute(
      path: '/dashboard',
      name: AppRoute.dashboard.name,
      builder: (context, state) {
        return const DashboardPage();
      },
      routes: [
        GoRoute(
          path: '/create-bot',
          name: AppRoute.createBot.name,
          builder: (context, state) => const CreateBotPage(),
        ),
        GoRoute(
          path: '/order-details',
          name: AppRoute.createBot.name,
          builder: (context, state) {
            //TODO CHANGE
            final orderData = state.extra as OrderData;
            return OrderDetailsPage(orderData);
          },
        ),
        GoRoute(
          path: '/run-order-history',
          name: AppRoute.runOrderHistory.name,
          builder: (context, state) {
            //TODO CHANGE
            final runOrders = state.extra as RunOrders;
            return RunOrderHistoryPage(runOrders);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      name: AppRoute.settings.name,
      builder: (context, state) => const SettingsPage(),
      routes: [
        GoRoute(
          path: '/binance-api-settings',
          name: AppRoute.binanceApiSettings.name,
          builder: (context, state) => BinanceApiSettingsPage(),
        ),
      ],
    ),
  ],
  // errorBuilder: (context, state) => const NotFoundScreen(),
);
