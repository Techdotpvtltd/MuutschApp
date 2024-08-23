// Project: 	   muutsch
// File:    	   push_notification_state
// Path:    	   lib/blocs/push_notification/push_notification_state.dart
// Author:       Ali Akbar
// Date:        20-05-24 18:48:23 -- Monday
// Description:

abstract class PushNotificationState {}

/// Initial State
class PushNotificationStateInitial extends PushNotificationState {}

class PushNotificationStateUserSubscribed extends PushNotificationState {}

class PushNotificationStateUserUnSubscribed extends PushNotificationState {}

class PushNotificationStateEventSubscribed extends PushNotificationState {}

class PushNotificationStateEventUnSubscribed extends PushNotificationState {}

class PushNotificationStateMessageServiceSubscribed
    extends PushNotificationState {}

class PushNotificationStateMessageServiceUnSubscribed
    extends PushNotificationState {}

//// Fire States
class PushNotificationStateFireFriendRequest extends PushNotificationState {}

class PushNotificationStateFireEventUpdates extends PushNotificationState {}
