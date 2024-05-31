// ignore_for_file: public_member_api_docs, sort_constructors_first
// Project: 	   muutsch
// File:    	   chat_model
// Path:    	   lib/models/chat_model.dart
// Author:       Ali Akbar
// Date:        31-05-24 12:02:07 -- Friday
// Description:

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'light_user_model.dart';

class ChatModel {
  final String uuid;
  final DateTime createdAt;
  final String createdBy;
  final List<LightUserModel> participants;
  final List<String> participantUids;
  final bool isChatEnabled;
  final bool isGroup;
  final String? groupTitle;
  final String? groupAvatar;
  final String compositeKey;
  ChatModel({
    required this.uuid,
    required this.createdAt,
    required this.createdBy,
    required this.participants,
    required this.participantUids,
    required this.isChatEnabled,
    required this.isGroup,
    this.groupTitle,
    this.groupAvatar,
    required this.compositeKey,
  });

  ChatModel copyWith({
    String? uuid,
    DateTime? createdAt,
    String? createdBy,
    List<LightUserModel>? participants,
    List<String>? participantUids,
    bool? isChatEnabled,
    bool? isGroup,
    String? groupTitle,
    String? groupAvatar,
    String? compositeKey,
  }) {
    return ChatModel(
      uuid: uuid ?? this.uuid,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      participants: participants ?? this.participants,
      participantUids: participantUids ?? this.participantUids,
      isChatEnabled: isChatEnabled ?? this.isChatEnabled,
      isGroup: isGroup ?? this.isGroup,
      groupTitle: groupTitle ?? this.groupTitle,
      groupAvatar: groupAvatar ?? this.groupAvatar,
      compositeKey: compositeKey ?? this.compositeKey,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
      'participants': participants.map((x) => x.toMap()).toList(),
      'participantUids': participantUids,
      'isChatEnabled': isChatEnabled,
      'isGroup': isGroup,
      'groupTitle': groupTitle,
      'groupAvatar': groupAvatar,
      'compositeKey': compositeKey,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      uuid: map['uuid'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      createdBy: map['createdBy'] as String,
      participants: (map['participants'] as List<dynamic>)
          .map((e) => LightUserModel.fromMap(e))
          .toList(),
      participantUids: List<String>.from(map['participantUids'] as List),
      isChatEnabled: map['isChatEnabled'] as bool,
      isGroup: map['isGroup'] as bool,
      groupTitle: map['groupTitle'] as String?,
      groupAvatar: map['groupAvatar'] as String?,
      compositeKey: map['compositeKey'] as String? ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatModel(uuid: $uuid, createdAt: $createdAt, createdBy: $createdBy, participants: $participants, participantUids: $participantUids, isChatEnabled: $isChatEnabled, isGroup: $isGroup, groupTitle: $groupTitle, groupAvatar: $groupAvatar, compositeKey: $compositeKey)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid &&
        other.createdAt == createdAt &&
        other.createdBy == createdBy &&
        listEquals(other.participants, participants) &&
        listEquals(other.participantUids, participantUids) &&
        other.isChatEnabled == isChatEnabled &&
        other.isGroup == isGroup &&
        other.groupTitle == groupTitle &&
        other.compositeKey == compositeKey &&
        other.groupAvatar == groupAvatar;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        createdAt.hashCode ^
        createdBy.hashCode ^
        participants.hashCode ^
        participantUids.hashCode ^
        isChatEnabled.hashCode ^
        isGroup.hashCode ^
        groupTitle.hashCode ^
        compositeKey.hashCode ^
        groupAvatar.hashCode;
  }
}
