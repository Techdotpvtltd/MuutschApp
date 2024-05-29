// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// Project: 	   muutsch
// File:    	   join_event_model
// Path:    	   lib/models/join_event_model.dart
// Author:       Ali Akbar
// Date:        16-05-24 15:39:03 -- Thursday
// Description:

class JoinMemberModel {
  final String uuid;
  final String joinerId;
  final DateTime joinTime;
  final String eventId;
  final String name;
  final String avatar;

  JoinMemberModel({
    required this.uuid,
    required this.joinerId,
    required this.joinTime,
    required this.eventId,
    required this.name,
    required this.avatar,
  });

  JoinMemberModel copyWith({
    String? uuid,
    String? joinerId,
    DateTime? joinTime,
    String? eventId,
    String? name,
    String? avatar,
  }) {
    return JoinMemberModel(
      uuid: uuid ?? this.uuid,
      joinerId: joinerId ?? this.joinerId,
      joinTime: joinTime ?? this.joinTime,
      eventId: eventId ?? this.eventId,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'joinerId': joinerId,
      'joinTime': Timestamp.fromDate(joinTime),
      'eventId': eventId,
      'name': name,
      'avatar': avatar,
    };
  }

  factory JoinMemberModel.fromMap(Map<String, dynamic> map) {
    return JoinMemberModel(
      uuid: map['uuid'] as String,
      joinerId: map['joinerId'] as String,
      joinTime: (map['joinTime'] as Timestamp).toDate(),
      eventId: map['eventId'] as String,
      name: map['name'] as String? ?? "",
      avatar: map['avatar'] as String? ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory JoinMemberModel.fromJson(String source) =>
      JoinMemberModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'JoinEventModel(uuid: $uuid, joinerId: $joinerId, joinTime: $joinTime, eventId: $eventId, name: $name, avatar: $avatar)';
  }

  @override
  bool operator ==(covariant JoinMemberModel other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid &&
        other.joinerId == joinerId &&
        other.joinTime == joinTime &&
        other.eventId == eventId;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        joinerId.hashCode ^
        joinTime.hashCode ^
        eventId.hashCode;
  }
}
