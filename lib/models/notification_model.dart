// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// Project: 	   muutsch
// File:    	   notification_model
// Path:    	   lib/models/notification_model.dart
// Author:       Ali Akbar
// Date:        29-05-24 16:38:40 -- Wednesday
// Description:

class NotificationModel {
  final String uuid;
  final String title;
  final String message;
  final String senderId;
  final String receiverId;
  final NotificationType type;
  final DateTime createdAt;
  final String contentId;
  final String avatar;
  final Map<String, dynamic>? data;
  NotificationModel({
    required this.uuid,
    required this.title,
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.createdAt,
    required this.contentId,
    required this.avatar,
    this.data,
  });

  NotificationModel copyWith({
    String? uuid,
    String? title,
    String? message,
    String? senderId,
    String? receiverId,
    NotificationType? type,
    DateTime? createdAt,
    String? contentId,
    String? avatar,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      message: message ?? this.message,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      contentId: contentId ?? this.contentId,
      avatar: avatar ?? this.avatar,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'title': title,
      'message': message,
      'senderId': senderId,
      'receiverId': receiverId,
      'type': type.name.toLowerCase(),
      'createdAt': Timestamp.fromDate(createdAt),
      'contentId': contentId,
      'avatar': avatar,
      'data': data,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      uuid: map['uuid'] as String,
      title: map['title'] as String,
      message: map['message'] as String,
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      type: NotificationType.values.firstWhere((element) =>
          element.name.toLowerCase() == (map['type'] as String).toLowerCase()),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      contentId: map['contentId'] as String,
      avatar: map['avatar'] as String,
      data: (map['data'] != null) ? map['data'] as Map<String, dynamic> : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(uuid: $uuid, title: $title, message: $message, senderId: $senderId, recieverId: $receiverId, type: $type, createdAt: $createdAt, contentId: $contentId, avatar: $avatar, data: $data)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid &&
        other.title == title &&
        other.message == message &&
        other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.type == type &&
        other.createdAt == createdAt &&
        other.avatar == avatar &&
        other.contentId == contentId;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        title.hashCode ^
        message.hashCode ^
        senderId.hashCode ^
        receiverId.hashCode ^
        type.hashCode ^
        createdAt.hashCode ^
        avatar.hashCode ^
        contentId.hashCode;
  }
}

enum NotificationType { user, event, chat }
