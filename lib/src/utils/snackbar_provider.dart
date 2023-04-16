import 'package:binander/src/constants/globals.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'snackbar_provider.g.dart';

@riverpod
SnackBarProvider snackBar() => const SnackBarProvider();

class SnackBarProvider {
  const SnackBarProvider();

  void show(String message, {bool dismissable = false, int seconds = 3}) {
    final snackBar = SnackBar(
      duration: Duration(seconds: seconds),
      content: Text(message),
      action: SnackBarAction(
        label: 'Okay',
        //TODO update onPressed
        onPressed: () {},
      ),
    );

    snackbarKey.currentState?.showSnackBar(snackBar);
  }
}
