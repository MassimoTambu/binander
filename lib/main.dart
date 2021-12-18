import 'package:bottino_fortino/models/models.dart';
import 'package:bottino_fortino/modules/dashboard/screens/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BottinoFortino());
}

class BottinoFortino extends StatelessWidget {
  const BottinoFortino({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeLight,
      darkTheme: themeDark,
      themeMode: ThemeMode.dark,
      home: const Dashboard(),
    );
  }
}
