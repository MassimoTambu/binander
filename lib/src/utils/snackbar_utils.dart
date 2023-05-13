import 'package:binander/src/constants/globals.dart';
import 'package:flutter/material.dart';

void showSnackBarAction(String message,
    {bool dismissable = false, int seconds = 3}) {
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
