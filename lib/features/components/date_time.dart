import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

class DateTimeUtils {
  static tz.Location get mozambiqueLocation => tz.getLocation('Africa/Maputo');

  static DateTime convertToMozambiqueTime(DateTime dateTime) {
    return tz.TZDateTime.from(dateTime, mozambiqueLocation);
  }

  static String formatToMozambiqueTime(DateTime dateTime) {
    final mozTime = convertToMozambiqueTime(dateTime);
    return DateFormat('dd/MM/yyyy HH:mm').format(mozTime);
  }

  static DateTime nowInMozambique() {
    return tz.TZDateTime.now(mozambiqueLocation);
  }
}