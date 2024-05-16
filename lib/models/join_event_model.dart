// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// Project: 	   muutsch
// File:    	   join_event_model
// Path:    	   lib/models/join_event_model.dart
// Author:       Ali Akbar
// Date:        16-05-24 15:39:03 -- Thursday
// Description:

class JoinEventModel {
  final String uuid;
  final String joinerId;
  final DateTime joinTime;
  final String eventId;
  JoinEventModel({
    required this.uuid,
    required this.joinerId,
    required this.joinTime,
    required this.eventId,
  });

  JoinEventModel copyWith({
    String? uuid,
    String? joinerId,
    DateTime? joinTime,
    String? eventId,
  }) {
    return JoinEventModel(
      uuid: uuid ?? this.uuid,
      joinerId: joinerId ?? this.joinerId,
      joinTime: joinTime ?? this.joinTime,
      eventId: eventId ?? this.eventId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'joinerId': joinerId,
      'joinTime': Timestamp.fromDate(joinTime),
      'eventId': eventId,
    };
  }

  factory JoinEventModel.fromMap(Map<String, dynamic> map) {
    return JoinEventModel(
      uuid: map['uuid'] as String,
      joinerId: map['joinerId'] as String,
      joinTime: (map['joinTime'] as Timestamp).toDate(),
      eventId: map['eventId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory JoinEventModel.fromJson(String source) =>
      JoinEventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'JoinEventModel(uuid: $uuid, joinerId: $joinerId, joinTime: $joinTime, eventId: $eventId)';
  }

  @override
  bool operator ==(covariant JoinEventModel other) {
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
