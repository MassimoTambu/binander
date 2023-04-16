// TODO IS IT REALLY USEFUL???
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

  static double? nullStringToDouble(String? number) {
    if (number == null) return null;

    return double.parse(number);
  }

  static String? nullDoubleToString(double? number) {
    if (number == null) return null;

    return "$number";
  }

  static DateTime unixToDateTime(int unix) {
    return DateTime.fromMillisecondsSinceEpoch(unix, isUtc: true);
  }

  static int dateTimeToUnix(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch;
  }

  static DateTime? nullUnixToDateTime(int? unix) {
    if (unix == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(unix, isUtc: true);
  }

  static int? nullDateTimeToUnix(DateTime? dateTime) {
    if (dateTime == null) return null;

    return dateTime.millisecondsSinceEpoch;
  }
}
