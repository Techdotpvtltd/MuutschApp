// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// Project: 	   muutsch
// File:    	   friend_model
// Path:    	   lib/models/friend_model.dart
// Author:       Ali Akbar
// Date:        17-05-24 14:02:57 -- Friday
// Description:

class FriendModel {
  final String uuid;
  final String senderId;
  final List<String> participants;
  final String recieverId;
  final FriendType type;
  final DateTime requestSendTime;
  final DateTime? requestAcceptTime;
  FriendModel({
    required this.uuid,
    required this.senderId,
    required this.participants,
    required this.recieverId,
    required this.type,
    required this.requestSendTime,
    this.requestAcceptTime,
  });

  FriendModel copyWith({
    String? uuid,
    String? senderId,
    List<String>? participants,
    String? recieverId,
    FriendType? type,
    DateTime? requestSendTime,
    DateTime? requestAcceptTime,
  }) {
    return FriendModel(
      uuid: uuid ?? this.uuid,
      senderId: senderId ?? this.senderId,
      participants: participants ?? this.participants,
      recieverId: recieverId ?? this.recieverId,
      type: type ?? this.type,
      requestSendTime: requestSendTime ?? this.requestSendTime,
      requestAcceptTime: requestAcceptTime ?? this.requestAcceptTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'senderId': senderId,
      'participants': participants,
      'recieverId': recieverId,
      'type': type.name.toLowerCase(),
      'requestSendTime': Timestamp.fromDate(requestSendTime),
      'requestAcceptTime': requestAcceptTime != null
          ? Timestamp.fromDate(requestAcceptTime!)
          : null,
    };
  }

  factory FriendModel.fromMap(Map<String, dynamic> map) {
    return FriendModel(
      uuid: map['uuid'] as String,
      senderId: map['senderId'] as String,
      participants: (map['participants'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      recieverId: map['recieverId'] as String,
      type: FriendType.values.firstWhere((element) =>
          element.name.toLowerCase() ==
          (map['type'] as String? ?? "request").toLowerCase()),
      requestSendTime: (map['requestSendTime'] as Timestamp).toDate(),
      requestAcceptTime: (map['requestAcceptTime'] as Timestamp?)?.toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendModel.fromJson(String source) =>
      FriendModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FriendModel(uuid: $uuid, senderId: $senderId, participants: $participants, recieverId: $recieverId, type: $type, requestSendTime: $requestSendTime, requestAcceptTime: $requestAcceptTime)';
  }

  @override
  bool operator ==(covariant FriendModel other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid &&
        other.senderId == senderId &&
        listEquals(other.participants, participants) &&
        other.recieverId == recieverId &&
        other.type == type &&
        other.requestSendTime == requestSendTime &&
        other.requestAcceptTime == requestAcceptTime;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        senderId.hashCode ^
        participants.hashCode ^
        recieverId.hashCode ^
        type.hashCode ^
        requestSendTime.hashCode ^
        requestAcceptTime.hashCode;
  }
}

enum FriendType { request, friend, rejected, remove }
