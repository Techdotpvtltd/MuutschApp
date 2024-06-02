// Project: 	   burns_construction
// File:    	   helping_methods
// Path:    	   lib/utils/helping_methods.dart
// Author:       Ali Akbar
// Date:        13-02-24 14:31:50 -- Tuesday
// Description:
//
import 'dart:math';

import 'package:musch/utils/extensions/date_extension.dart';

//// Haversine formula for calculating the distance between two geographical points
double calculateDistance({
  required double aLat,
  required double aLong,
  required double bLat,
  required double bLong,
}) {
  const double earthRadius = 6371; // Radius of the Earth in kilometers
  final double dLat = _deg2rad(bLat - aLat);
  final double dLon = _deg2rad(bLong - aLong);

  final double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_deg2rad(aLat)) * cos(_deg2rad(bLat)) * sin(dLon / 2) * sin(dLon / 2);

  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  final double distance = earthRadius * c;

  return distance;
}

double _deg2rad(double deg) {
  return deg * (pi / 180);
}


String? formatChatDateToString(DateTime? dateTime) {
  if (dateTime == null) {
    return "";
  }
  final days = DateTime.now().difference(dateTime).inDays;
  if (days == 0) {
    return dateTime.dateToString("hh:mm a");
  }
  if (days == 1) {
    return "Yesterday at ${dateTime.dateToString("hh:mm a")}";
  }

  return dateTime.dateToString("dd-MMM-yyyy hh:mm a");
}