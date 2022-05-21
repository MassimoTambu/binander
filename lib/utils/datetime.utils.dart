import 'package:intl/intl.dart';

class DateTimeUtils {
  static String toHmsddMMy(DateTime dateTime) {
    final formatter = DateFormat('H:mm:ss dd-MM-y');
    return formatter.format(dateTime.toLocal());
  }
}
