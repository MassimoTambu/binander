part of utils;

class ParseUtils {
  static int stringToInt(String number) {
    return int.parse(number);
  }

  static double stringToDouble(String number) {
    return double.parse(number);
  }

  static DateTime unixToDateTime(int unix) {
    return DateTime.fromMillisecondsSinceEpoch(unix, isUtc: true);
  }
}
