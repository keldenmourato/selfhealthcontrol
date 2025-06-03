import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toFormattedString() {
    return DateFormat('dd/MM/yyyy HH:mm').format(this);
  }
}