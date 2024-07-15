import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DateTimeFormat {
  static String formatToHmmWith12Hour(
      DateTime time, Locale locale, String datePattern) {
    String formatDate = "";
    DateFormat formatter;
    if (datePattern.isNotEmpty) {
      formatter = DateFormat(datePattern).add_Hm();
    } else {
      formatter = DateFormat.yMd(locale.toString()).add_Hm();
    }
    formatDate = formatter.format(time);
    return formatDate;
  }
}
