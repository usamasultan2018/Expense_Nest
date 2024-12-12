import 'package:intl/intl.dart';

class DateTimeUtils {
  // Format date as MM/dd/yyyy
  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
    return formatter.format(date);
  }

  // Format date as yyyy-MM-dd
  static String formatDateISO(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  // Format date as MMM d, yyyy
  static String formatDateFull(DateTime date) {
    final DateFormat formatter = DateFormat('MMM d, yyyy');
    return formatter.format(date);
  }

  // Format time as HH:mm:ss
  static String formatTime(DateTime date) {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(date);
  }

  // Format time as h:mm a (12-hour format)
  static String formatTime12Hour(DateTime date) {
    final DateFormat formatter = DateFormat('h:mm a');
    return formatter.format(date);
  }

  // Format date and time as MMM d, yyyy 'at' h:mm a
  static String formatDateTime(DateTime date) {
    final DateFormat formatter = DateFormat('MMM d, yyyy \'at\' h:mm a');
    return formatter.format(date);
  }

  // Format date and time as yyyy-MM-dd HH:mm:ss
  static String formatDateTimeISO(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(date);
  }

  // Format date and time as MMM d, yyyy 'at' HH:mm
  static String formatDateTimeFull(DateTime date) {
    final DateFormat formatter = DateFormat('MMM d, yyyy \'at\' HH:mm');
    return formatter.format(date);
  }
   static String formatDateMonthDayYear(DateTime date) {
    final DateFormat formatter = DateFormat('MMM d, yyyy');
    return formatter.format(date);
  }
}
