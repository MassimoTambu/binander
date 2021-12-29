part of services;

class SnackBarService {
  static final _singleton = SnackBarService._internal();

  factory SnackBarService() {
    return _singleton;
  }

  SnackBarService._internal();

  void show(BuildContext context, String message, {bool dismissable = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Okay',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
