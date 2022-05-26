import 'package:bottino_fortino/models/constants/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final snackBarProvider = Provider<SnackBarProvider>((ref) {
  return SnackBarProvider();
});

class SnackBarProvider {
  void show(String message, {bool dismissable = false, int seconds = 3}) {
    final snackBar = SnackBar(
      duration: Duration(seconds: seconds),
      content: Text(message),
      action: SnackBarAction(
        label: 'Okay',
        onPressed: () {},
      ),
    );

    snackbarKey.currentState?.showSnackBar(snackBar);
  }
}
