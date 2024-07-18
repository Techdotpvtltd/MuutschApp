// ignore_for_file: public_member_api_docs, sort_constructors_first
// Project: 	   muutsch
// File:    	   event_model
// Path:    	   lib/models/event_model.dart
// Author:       Ali Akbar
// Date:        14-05-24 15:53:42 -- Tuesday
// Description:

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:musch/models/other_user_model.dart';

import 'location_model.dart';

class EventModel {
  final String id;
  final OtherUserModel creatorDetail;
  final String createdBy;
  final DateTime createdAt;
  final List<String> imageUrls;
  final String title;
  final DateTime dateTime;
  final LocationModel location;
  final String? description;
  final int maxPersons;
  final List<OtherUserModel> joinMemberDetails;
  final List<String> joinMemberIds;

  double distance;
  EventModel({
    required this.id,
    required this.creatorDetail,
    required this.createdAt,
    required this.imageUrls,
    required this.title,
    required this.createdBy,
    required this.dateTime,
    required this.location,
    required this.joinMemberDetails,
    this.description,
    required this.maxPersons,
    this.distance = 0,
    required this.joinMemberIds,
  });

  String toJson() => json.encode(toMap(isFromJson: true));

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source) as Map<String, dynamic>,
          isFromJson: true);

  EventModel copyWith({
    String? id,
    OtherUserModel? creatorDetail,
    DateTime? createdAt,
    List<String>? imageUrls,
    String? title,
    String? createdBy,
    DateTime? dateTime,
    LocationModel? location,
    String? description,
    int? maxPersons,
    List<String>? joinMemberIds,
    List<OtherUserModel>? joinMemberDetails,
  }) {
    return EventModel(
      id: id ?? this.id,
      creatorDetail: creatorDetail ?? this.creatorDetail,
      createdAt: createdAt ?? this.createdAt,
      imageUrls: imageUrls ?? this.imageUrls,
      title: title ?? this.title,
      createdBy: createdBy ?? this.createdBy,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      description: description ?? this.description,
      maxPersons: maxPersons ?? this.maxPersons,
      joinMemberIds: joinMemberIds ?? this.joinMemberIds,
      joinMemberDetails: joinMemberDetails ?? this.joinMemberDetails,
    );
  }

  Map<String, dynamic> toMap({bool isFromJson = false}) {
    return <String, dynamic>{
      'id': id,
      'creatorDetail': creatorDetail.toMap(isToJson: isFromJson),
      'createdAt': isFromJson
          ? createdAt.millisecondsSinceEpoch
          : Timestamp.fromDate(createdAt),
      'imageUrls': imageUrls,
      'title': title,
      'createdBy': createdBy,
      'dateTime': isFromJson
          ? dateTime.millisecondsSinceEpoch
          : Timestamp.fromDate(dateTime),
      'location': location.toMap(),
      'description': description,
      'maxPersons': maxPersons,
      'joinMemberIds': joinMemberIds,
      'joinMemberDetails':
          joinMemberDetails.map((e) => e.toMap(isToJson: isFromJson)).toList(),
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map,
      {bool isFromJson = false}) {
    return EventModel(
        id: map['id'] as String,
        createdBy: map['createdBy'] as String,
        creatorDetail: OtherUserModel.fromMap(
            map['creatorDetail'] as Map<String, dynamic>),
        createdAt: isFromJson
            ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
            : (map['createdAt'] as Timestamp).toDate(),
        imageUrls: List<String>.from((map['imageUrls'] as List<dynamic>).map(
          (e) => e.toString(),
        )),
        title: map['title'] as String,
        joinMemberIds: map['joinMemberIds'] == null
            ? []
            : (map['joinMemberIds'] as List).map((e) => (e as String)).toList(),
        dateTime: (map['dateTime'] as Timestamp).toDate(),
        location:
            LocationModel.fromMap(map['location'] as Map<String, dynamic>),
        description:
            map['description'] != null ? map['description'] as String : null,
        maxPersons: map['maxPersons'] as int? ?? 0,
        joinMemberDetails: map['joinMemberDetails'] == null
            ? []
            : (map['joinMemberDetails'] as List)
                .map((e) => OtherUserModel.fromMap((e as Map<String, dynamic>)))
                .toList());
  }
  @override
  String toString() {
    return 'EventModel(id: $id, createdBy: $creatorDetail, createdAt: $createdAt, imageUrls: $imageUrls, title: $title, dateTime: $dateTime, location: $location, description: $description, maxPersons: $maxPersons, joinMemberDetails: $joinMemberDetails)';
  }

  @override
  bool operator ==(covariant EventModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.creatorDetail == creatorDetail &&
        other.createdAt == createdAt &&
        listEquals(other.imageUrls, imageUrls) &&
        other.title == title &&
        other.dateTime == dateTime &&
        other.location == location &&
        other.maxPersons == maxPersons &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        creatorDetail.hashCode ^
        createdAt.hashCode ^
        imageUrls.hashCode ^
        title.hashCode ^
        dateTime.hashCode ^
        location.hashCode ^
        maxPersons.hashCode ^
        description.hashCode;
  }
}
