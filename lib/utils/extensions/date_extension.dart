import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  DateTime onlyDate() {
    return DateTime(year, month, day);
  }

  TimeOfDay onlyTime() {
    return TimeOfDay(hour: hour, minute: minute);
  }

  String dateToString(String pattern) {
    return DateFormat(pattern).format(this);
  }

  String formatChatDateToString() {
    final days = DateTime.now().difference(this).inDays;
    if (days == 0) {
      return "Today";
    }
    if (days == 1) {
      return "Yesterday";
    }

    if (days > 1 && days < 7) {
      return dateToString("EEEE");
    }
    return dateToString("dd-MMM-yyyy");
  }
}

DateTime monthStartDay() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
}
