import 'package:intl/intl.dart';

class DateTimeUtils {
  static String toHmsddMMy(DateTime dateTime) {
    final formatter = DateFormat('H:m:s dd-MM-y');
    return formatter.format(dateTime);
  }
}
