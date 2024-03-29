import 'dart:async';

/// Use to prevent making more than one request due to the user input
class Debounce {
  Duration delay;
  Timer? _timer;

  Debounce(this.delay);

  void call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  void dispose() {
    _timer?.cancel();
  }
}
