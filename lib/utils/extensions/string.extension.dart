part of utils;

extension Capitalize on String {
  String capitalizeFirst() {
    return this[0].toUpperCase() + substring(1);
  }
}
