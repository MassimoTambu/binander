import 'package:bottino_fortino/models/models.dart';
import 'package:bottino_fortino/modules/settings/settings.dart';
import 'package:bottino_fortino/router/app_router.dart';
import 'package:bottino_fortino/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(BottinoFortino());
}

class BottinoFortino extends StatelessWidget {
  BottinoFortino({Key? key}) : super(key: key);

  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MemoryStorageService().init(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ChangeNotifierProvider(
            create: (context) => SettingsNotifier(),
            child: Consumer(
              builder: (context, value, child) {
                return MaterialApp.router(
                  routerDelegate: _router.delegate(),
                  routeInformationProvider: _router.routeInfoProvider(),
                  routeInformationParser: _router.defaultRouteParser(),
                  theme: themeLight,
                  darkTheme: themeDark,
                  themeMode: context.watch<SettingsNotifier>().themeMode,
                );
              },
            ),
          );
        }

        return Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
