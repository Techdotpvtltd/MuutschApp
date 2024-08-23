// Project: 	   muutsch
// File:    	   psuh_notification_event
// Path:    	   lib/blocs/push_notification/psuh_notification_event.dart
// Author:       Ali Akbar
// Date:        20-05-24 18:52:03 -- Monday
// Description:

abstract class PushNotificationEvent {}

/// Send Friend Request Event
class pushNotificationEventFireFriendRequest extends PushNotificationEvent {
  final String recieverId;
  final String message;
  final String title;
  pushNotificationEventFireFriendRequest(
      {required this.recieverId, required this.message, required this.title});
}

/// Send Friend Request Event
class pushNotificationEventFireEventsUpdate extends PushNotificationEvent {
  final String eventId;
  final String message;

  pushNotificationEventFireEventsUpdate(
      {required this.eventId, required this.message});
}

/// User Subscribed and UnSubscribed
class PushNotificationEventUserSubscribed extends PushNotificationEvent {}

class PushNotificationEventUserUnSubscribed extends PushNotificationEvent {}

/// Event Subscribed and UnSubscribed

class PushNotificationEventEventsSubscribed extends PushNotificationEvent {
  final String eventId;

  PushNotificationEventEventsSubscribed({required this.eventId});
}

class PushNotificationEventEventsUnSubscribed extends PushNotificationEvent {
  final String eventId;

  PushNotificationEventEventsUnSubscribed({required this.eventId});
}
