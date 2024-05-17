// Project: 	   muutsch
// File:    	   friend_event
// Path:    	   lib/blocs/friend/friend_event.dart
// Author:       Ali Akbar
// Date:        17-05-24 14:21:16 -- Friday
// Description:

abstract class FriendEvent {}

/// SendRequest Event

class FriendEventSend extends FriendEvent {
  final String recieverId;

  FriendEventSend({required this.recieverId});
}

/// FetchFriends Event
class FriendEventFetch extends FriendEvent {}

/// FetchPendingRequest Event
class FriendEventFetchPendingRequests extends FriendEvent {}
