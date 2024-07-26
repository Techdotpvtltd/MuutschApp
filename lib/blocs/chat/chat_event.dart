// Project: 	   muutsch
// File:    	   chat_event
// Path:    	   lib/blocs/chat/chat_event.dart
// Author:       Ali Akbar
// Date:        31-05-24 13:34:57 -- Friday
// Description:

import 'package:musch/models/chat_model.dart';
import 'package:musch/models/event_model.dart';

import '../../models/other_user_model.dart';

abstract class ChatEvent {}

/// Fetch All Event
class ChatEventFetchAll extends ChatEvent {}

/// Fetch Single Chat Event
class ChatEventFetch extends ChatEvent {
  final OtherUserModel friendProfile;

  ChatEventFetch({required this.friendProfile});
}

/// Create Chat Event
class ChatEventCreate extends ChatEvent {
  final bool isGroup;
  final bool isChatEnabled;
  String? chatTitle;
  String? chatAvatar;
  OtherUserModel? friendProfile;
  String? eventId;
  final List<String> ids;
  final EventModel? event;
  ChatEventCreate(
      {this.isGroup = false,
      this.isChatEnabled = true,
      this.chatAvatar,
      this.eventId,
      this.chatTitle,
      this.event,
      required this.ids,
      this.friendProfile});
}

class ChatEventUpdateVisibilityStatus extends ChatEvent {
  final bool status;
  final ChatModel chat;
  ChatEventUpdateVisibilityStatus({required this.status, required this.chat});
}

class ChatEventFetchGroupChat extends ChatEvent {
  final String eventId;
  final List<String> joinedMemberIds;
  final String eventTitle;

  ChatEventFetchGroupChat({
    required this.eventId,
    required this.joinedMemberIds,
    required this.eventTitle,
  });
}

class ChatEventJoinGroupChat extends ChatEvent {
  final String eventId;

  ChatEventJoinGroupChat({required this.eventId});
}

/// Remove Member
class ChatEventRemoveMember extends ChatEvent {
  final OtherUserModel member;
  final String chatId;
  ChatEventRemoveMember({required this.member, required this.chatId});
}
