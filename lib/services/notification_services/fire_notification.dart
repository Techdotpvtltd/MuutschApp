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
// FIXME
class FireNotification {
  final String serverKey =
      'AAAA47Au-sM:APA91bG4KYcpm0mab5ppugT8y6whJQhehm-nOqfIoFIUG1QCLEUMv0xAhuwpDEXmnm1udt5dj0PJk1Z4k3TAuJ4fI_xI_V0eYlJrtM_uSHIAouFPGvkMVHcF9Wifb-bV8W-h0Fi0_BNM';

  void sendNotification({
    required String title,
    required String description,
    required String topic,
    required String type,
    Map<String, dynamic>? additionalData,
  }) async {
    const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

    // Payload for the notification
    final String toTopic = '$topic${kDebugMode ? "-Rel" : "-Rel"}';
    final Map<String, dynamic> notification = {
      'to': '/topics/$toTopic',
      'notification': {'title': title, 'body': description},
      'data': {
        'type': type,
        "additionalData": additionalData,
      }
    };
    // Send the HTTP POST request to FCM endpoint
    final http.Response response = await http.post(
      Uri.parse(fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(notification),
    );

    // Check the response
    if (response.statusCode == 200) {
      debugPrint('Notification sent for topic; $toTopic');
    } else {
      debugPrint(
          'Failed to send notification to topic: $toTopic\nError: ${response.body}');
    }
  }
}
