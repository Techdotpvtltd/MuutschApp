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

class FriendEventFetchFriends extends FriendEvent {}

/// Get Friend Info
class FriendEventGet extends FriendEvent {
  final String friendId;

  FriendEventGet({required this.friendId});
}

// ===========================Accept Friend Request Event================================
class FriendEventAccept extends FriendEvent {
  final String friendId;

  FriendEventAccept({required this.friendId});
}

// ===========================Reject Friend Request Event================================
class FriendEventReject extends FriendEvent {
  final String friendId;

  FriendEventReject({required this.friendId});
}

// ===========================Remove Friend Request Event================================
class FriendEventRemove extends FriendEvent {
  final String friendId;

  FriendEventRemove({required this.friendId});
}
