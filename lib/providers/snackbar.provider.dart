part of providers;

final snackBarProvider = Provider<SnackBarProvider>((ref) {
  return SnackBarProvider();
});

class SnackBarProvider {
  void show(String message, {bool dismissable = false}) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(message),
      action: SnackBarAction(
        label: 'Okay',
        onPressed: () {},
      ),
    );

    snackbarKey.currentState?.showSnackBar(snackBar);
  }
}
