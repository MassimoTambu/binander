part of utils;

class ParseUtils {
  static int stringToInt(String number) {
    return int.parse(number);
  }

  static String intToString(int number) {
    return "$number";
  }

  static double stringToDouble(String number) {
    return double.parse(number);
  }

  static String doubleToString(double number) {
    return "$number";
  }

  static DateTime unixToDateTime(int unix) {
    return DateTime.fromMillisecondsSinceEpoch(unix, isUtc: true);
  }

  static int dateTimeToUnix(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch;
  }
}
