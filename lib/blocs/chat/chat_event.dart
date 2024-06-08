// Project: 	   muutsch
// File:    	   chat_event
// Path:    	   lib/blocs/chat/chat_event.dart
// Author:       Ali Akbar
// Date:        31-05-24 13:34:57 -- Friday
// Description:

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

  ChatEventCreate(
      {this.isGroup = false,
      this.isChatEnabled = true,
      this.chatAvatar,
      this.chatTitle,
      this.friendProfile});
}
