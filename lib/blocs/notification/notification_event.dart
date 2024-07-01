// Project: 	   muutsch
// File:    	   notification_event
// Path:    	   lib/blocs/notification/notification_event.dart
// Author:       Ali Akbar
// Date:        29-05-24 17:10:10 -- Wednesday
// Description:

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../models/notification_model.dart';

abstract class NotificationEvent {}

/// Save
class NotificationEventSave extends NotificationEvent {
  final String receiverId;
  final String? contentId;
  final String title;
  final String message;
  final NotificationType type;

  NotificationEventSave(
      {required this.receiverId,
      required this.contentId,
      required this.title,
      required this.message,
      required this.type});
}

/// Fetch All
class NotificationEventFetch extends NotificationEvent {}

class NotificationEventMarkReadable extends NotificationEvent {}

/// On Recieved Push Notification
class NotificationEventOnReceivedPushNotification extends NotificationEvent {
  final RemoteMessage message;

  NotificationEventOnReceivedPushNotification({required this.message});
}

class NotificationEventDelete extends NotificationEvent {
  final String notificationId;

  NotificationEventDelete({required this.notificationId});
}
