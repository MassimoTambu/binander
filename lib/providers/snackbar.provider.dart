part of providers;

final snackBarProvider = Provider<SnackBarProvider>((ref) {
  return SnackBarProvider();
});

class SnackBarProvider {
  void show(BuildContext context, String message, {bool dismissable = false}) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(
        message,
        style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      action: SnackBarAction(
        label: 'Okay',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
