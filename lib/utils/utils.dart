import 'package:flutter/material.dart';

class Util {
  static bool isValidEmail({required String email}) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static DateTime? mergeDateTime({DateTime? dateTime, TimeOfDay? time}) {
    if (dateTime == null || time == null) return null;
    return DateTime(
        dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute);
  }
}
