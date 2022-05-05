part of utils;

extension DateOnlyCompare on DateTime {
  /// Check whether date has the same day, month and year of another
  bool isSameDate(DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }
}
