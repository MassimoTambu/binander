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
    AddBotRoute.name: (routeData) {
      final args = routeData.argsAs<AddBotRouteArgs>(
          orElse: () => const AddBotRouteArgs());
      return MaterialPageX<dynamic>(
          routeData: routeData, child: AddBotPage(key: args.key));
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(DashboardRoute.name, path: '/'),
        RouteConfig(SettingsRoute.name, path: '/settings-page'),
        RouteConfig(InfoRoute.name, path: '/info-page'),
        RouteConfig(AddBotRoute.name, path: '/add-bot-page')
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
/// [AddBotPage]
class AddBotRoute extends PageRouteInfo<AddBotRouteArgs> {
  AddBotRoute({Key? key})
      : super(AddBotRoute.name,
            path: '/add-bot-page', args: AddBotRouteArgs(key: key));

  static const String name = 'AddBotRoute';
}

class AddBotRouteArgs {
  const AddBotRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'AddBotRouteArgs{key: $key}';
  }
}
