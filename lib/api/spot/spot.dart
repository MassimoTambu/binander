part of api;

class Spot {
  static final Spot _singleton = Spot._internal();

  final trade = Trade();

  factory Spot() {
    return _singleton;
  }

  Spot._internal();
}
