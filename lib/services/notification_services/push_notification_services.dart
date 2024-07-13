import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Project: 	   burns_construction
/// File:    	   push_notification_services
/// Path:    	   lib/services/notification_services/push_notification_services.dart
/// Author:       Ali Akbar
/// Date:        15-02-24 15:42:55 -- Thursday
/// Description:
import 'package:rxdart/rxdart.dart';

import 'local_notification_services.dart';

class PushNotificationServices {
  static final PushNotificationServices _instance =
      PushNotificationServices._internal();
  PushNotificationServices._internal();
  Function(RemoteMessage message)? onNotificationReceived;
  factory PushNotificationServices() => _instance;

  late FirebaseMessaging _fcm;
  final messageStreamController = BehaviorSubject<RemoteMessage>();

  Future<void> initialize(
      {required Function(RemoteMessage message) onNotificationReceived}) async {
    _fcm = FirebaseMessaging.instance;
    this.onNotificationReceived = onNotificationReceived;
    debugPrint("FCM => ${await _fcm.getToken()}");
    debugPrint("isAllow Notification: ${await _checkForPermission()}");
  }

  Future<bool> _checkForPermission() async {
    final settings = await _fcm.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<void> subscribe({required String forTopic}) async {
    final String topic = '$forTopic${kDebugMode ? "-Dev" : "-Rel"}';
    await _fcm.subscribeToTopic(topic);
    debugPrint("Notification Subscribe topic: $topic");
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    _firebaseMessagingForgroundHandler();
  }

  Future<void> unsubscribe({required String forTopic}) async {
    final String topic = '$forTopic${kDebugMode ? "-Dev" : "-Rel"}';
    await _fcm.unsubscribeFromTopic(topic);
    debugPrint("Notification UnSubscribe topic: $topic");
    messageStreamController.close();
  }

  /// A notification will pass. When Click on notification in the background.
  Future<RemoteMessage?> getInitialMessage() async {
    return await _fcm.getInitialMessage();
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (onNotificationReceived != null) {
      onNotificationReceived!(message);
    }
    if (kDebugMode) {
      print("Handling a background message: ${message.messageId}");
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }
  }

  void _firebaseMessagingForgroundHandler() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (onNotificationReceived != null) {
        onNotificationReceived!(message);
      }
      // final String type = message.data['type'];
      // final additionalData = message.data['additionalData'];
      // final data = json.decode(additionalData) as Map<String, dynamic>;
      // final FriendModel friend =
      //     FriendModel.fromMap(data['friend'], isFromJson: true);
      // debugPrint(friend.toString());
      if (kDebugMode) {
        print('Handling a foreground message: ${message.messageId}');

        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
      }

      FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
          final String type = message.data['type'];
          if (type == 'message') {}

          if (kDebugMode) {
            print('Handling a foreground message: ${message.messageId}');
            print('Message data: ${message.data}');
            print('Message notification: ${message.notification?.title}');
            print('Message notification: ${message.notification?.body}');
          }
        },
      );

      LocalNotificationServices.showNotification(message);
    });
  }
}
