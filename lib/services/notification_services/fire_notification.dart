import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kDebugMode;

/// Project: 	   burns_construction_admin
/// File:    	   push_notification
/// Path:    	   lib/services/push_notifications/push_notification.dart
/// Author:       Ali Akbar
/// Date:        15-02-24 16:51:20 -- Thursday
/// Description:
class FireNotification {
  void sendNotification({
    required String title,
    required String description,
    required String topic,
    required String type,
    Map<String, dynamic>? additionalData,
  }) async {
    const String fcmUrl =
        'https://7s912iqqhf.execute-api.eu-north-1.amazonaws.com/pro';

    // Payload for the notification
    final String toTopic = '$topic${kDebugMode ? "-Dev" : "-Rel"}';
    final Map<String, dynamic> notification = {
      "message": {
        "topic": toTopic,
        'notification': {
          'title': title,
          'body': description,
        },
        'data': {
          'type': type,
          "additionalData": jsonEncode(additionalData),
        }
      },
    };

    debugPrint(notification.toString());
    // Send the HTTP POST request to FCM endpoint
    final http.Response response =
        await http.post(Uri.parse(fcmUrl), body: jsonEncode(notification));

    final responseBoday = jsonDecode(response.body) as Map<String, dynamic>;
    // Check the response
    if (responseBoday['status'] == 200) {
      debugPrint('Notification sent for topic; $toTopic');
      debugPrint(responseBoday.toString());
    } else {
      debugPrint(
          'Failed to send notification to topic: $toTopic\nError: ${responseBoday}');
    }
  }
}
