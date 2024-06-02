import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: dangling_library_doc_comments
/// Project: 	   wasteapp
/// File:    	   message_model
/// Path:    	   lib/models/message_model.dart
/// Author:       Ali Akbar
/// Date:        21-03-24 12:43:10 -- Thursday
/// Description:

class GroupedMessageModel {
  final DateTime date;
  final List<MessageModel> messages;

  GroupedMessageModel({required this.date, required this.messages});
  @override
  String toString() {
    return 'GroupedMessage(date: $date, messages: $messages)';
  }
}

class MessageModel {
  final String messageId;
  final String conversationId;
  final String content;
  final DateTime messageTime;
  final MessageType type;
  final String senderId;

  MessageModel({
    required this.messageId,
    required this.conversationId,
    required this.content,
    required this.messageTime,
    required this.type,
    required this.senderId,
  });

  MessageModel copyWith({
    String? messageId,
    String? conversationId,
    String? content,
    DateTime? messageTime,
    MessageType? type,
    String? senderId,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      conversationId: conversationId ?? this.conversationId,
      content: content ?? this.content,
      messageTime: messageTime ?? this.messageTime,
      type: type ?? this.type,
      senderId: senderId ?? this.senderId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageId': messageId,
      'conversationId': conversationId,
      'content': content,
      'messageTime': Timestamp.fromDate(messageTime),
      'type': type.name.toLowerCase(),
      'senderId': senderId,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
        messageId: map['messageId'] as String,
        conversationId: map['conversationId'] as String,
        content: map['content'] as String,
        messageTime: (map['messageTime'] as Timestamp).toDate(),
        type: MessageType.values.firstWhere((element) =>
            element.name.toLowerCase() == (map['type'] as String? ?? "text")),
        senderId: map['senderId'] as String);
  }

  @override
  String toString() {
    return 'MessageModel(messageId: $messageId, conversationId: $conversationId, content: $content, messageTime: $messageTime, type: $type, senderId: $senderId)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.messageId == messageId &&
        other.conversationId == conversationId &&
        other.content == content &&
        other.messageTime == messageTime &&
        other.senderId == senderId &&
        other.type == type;
  }

  @override
  int get hashCode {
    return messageId.hashCode ^
        conversationId.hashCode ^
        content.hashCode ^
        messageTime.hashCode ^
        senderId.hashCode ^
        type.hashCode;
  }
}

enum MessageType { text, photo, video }
