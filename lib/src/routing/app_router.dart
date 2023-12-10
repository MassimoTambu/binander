import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:binander/src/api/api.dart';
import 'package:binander/src/features/bot/domain/run_orders.dart';
import 'package:binander/src/features/bot/presentation/bot_tile/bot_tile_orders/order_detail_screen.dart';
import 'package:binander/src/features/bot/presentation/create_bot/create_bot_screen.dart';
import 'package:binander/src/features/bot/presentation/dashboard_screen.dart';
import 'package:binander/src/features/bot/presentation/run_order_history_screen.dart';
import 'package:binander/src/features/settings/presentation/binance_api_settings_screen.dart';
import 'package:binander/src/features/settings/presentation/settings_screen.dart';
import 'package:binander/src/routing/not_found_screen.dart';

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
        return const DashboardScreen();
      },
      routes: [
        GoRoute(
          path: 'create-bot',
          name: AppRoute.createBot.name,
          builder: (context, state) => const CreateBotScreen(),
        ),
        GoRoute(
          path: 'order-details',
          name: AppRoute.orderDetails.name,
          builder: (context, state) {
            //TODO CHANGE
            final orderData = state.extra as OrderData;
            return OrderDetailsScreen(orderData);
          },
        ),
        GoRoute(
          path: 'run-order-history',
          name: AppRoute.runOrderHistory.name,
          builder: (context, state) {
            //TODO CHANGE
            final runOrders = state.extra as RunOrders;
            return RunOrderHistoryScreen(runOrders);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      name: AppRoute.settings.name,
      builder: (context, state) => const SettingsScreen(),
      routes: [
        GoRoute(
          path: 'binance-api-settings',
          name: AppRoute.binanceApiSettings.name,
          builder: (context, state) => BinanceApiSettingsScreen(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);
