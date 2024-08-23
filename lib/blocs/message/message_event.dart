// ignore: dangling_library_doc_comments

import 'package:musch/models/chat_model.dart';

import '../../models/message_model.dart';

/// Project: 	   wasteapp
/// File:    	   message_event
/// Path:    	   lib/blocs/message/message_event.dart
/// Author:       Ali Akbar
/// Date:        21-03-24 14:56:30 -- Thursday
/// Description:

abstract class MessageEvent {}

// Fetch Messages Event
class MessageEventFetch extends MessageEvent {
  final String conversationId;

  MessageEventFetch({required this.conversationId});
}

// Send Message Event
class MessageEventSend extends MessageEvent {
  final String content;
  final MessageType type;
  final ChatModel chat;
  final String friendId;

  MessageEventSend(
      {required this.content,
      required this.type,
      required this.friendId,
      required this.chat});
}

class MessageEventNew extends MessageEvent {
  final bool isNew;

  MessageEventNew({required this.isNew});
}
