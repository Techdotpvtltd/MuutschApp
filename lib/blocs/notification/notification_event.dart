// Project: 	   muutsch
// File:    	   notification_event
// Path:    	   lib/blocs/notification/notification_event.dart
// Author:       Ali Akbar
// Date:        29-05-24 17:10:10 -- Wednesday
// Description:

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
