// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    DashboardRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const DashboardPage());
    },
    SettingsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const SettingsPage());
    },
    InfoRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const InfoPage());
    },
    CreateBotRoute.name: (routeData) {
      final args = routeData.argsAs<CreateBotRouteArgs>(
          orElse: () => const CreateBotRouteArgs());
      return MaterialPageX<dynamic>(
          routeData: routeData, child: CreateBotPage(key: args.key));
    },
    BinanceApiSettingsRoute.name: (routeData) {
      final args = routeData.argsAs<BinanceApiSettingsRouteArgs>(
          orElse: () => const BinanceApiSettingsRouteArgs());
      return MaterialPageX<dynamic>(
          routeData: routeData, child: BinanceApiSettingsPage(key: args.key));
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(DashboardRoute.name, path: '/'),
        RouteConfig(SettingsRoute.name, path: '/settings-page'),
        RouteConfig(InfoRoute.name, path: '/info-page'),
        RouteConfig(CreateBotRoute.name, path: '/create-bot-page'),
        RouteConfig(BinanceApiSettingsRoute.name,
            path: '/binance-api-settings-page')
      ];
}

/// generated route for
/// [DashboardPage]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute() : super(DashboardRoute.name, path: '/');

  static const String name = 'DashboardRoute';
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute() : super(SettingsRoute.name, path: '/settings-page');

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [InfoPage]
class InfoRoute extends PageRouteInfo<void> {
  const InfoRoute() : super(InfoRoute.name, path: '/info-page');

  static const String name = 'InfoRoute';
}

/// generated route for
/// [CreateBotPage]
class CreateBotRoute extends PageRouteInfo<CreateBotRouteArgs> {
  CreateBotRoute({Key? key})
      : super(CreateBotRoute.name,
            path: '/create-bot-page', args: CreateBotRouteArgs(key: key));

  static const String name = 'CreateBotRoute';
}

class CreateBotRouteArgs {
  const CreateBotRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'CreateBotRouteArgs{key: $key}';
  }
}

/// generated route for
/// [BinanceApiSettingsPage]
class BinanceApiSettingsRoute
    extends PageRouteInfo<BinanceApiSettingsRouteArgs> {
  BinanceApiSettingsRoute({Key? key})
      : super(BinanceApiSettingsRoute.name,
            path: '/binance-api-settings-page',
            args: BinanceApiSettingsRouteArgs(key: key));

  static const String name = 'BinanceApiSettingsRoute';
}

class BinanceApiSettingsRouteArgs {
  const BinanceApiSettingsRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'BinanceApiSettingsRouteArgs{key: $key}';
  }
}
