// ignore_for_file: public_member_api_docs, sort_constructors_first
// Project: 	   muutsch
// File:    	   event_model
// Path:    	   lib/models/event_model.dart
// Author:       Ali Akbar
// Date:        14-05-24 15:53:42 -- Tuesday
// Description:

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'location_model.dart';

class EventModel {
  final String id;
  final String createdBy;
  final DateTime createdAt;
  final List<String> imageUrls;
  final String title;
  final DateTime dateTime;
  final LocationModel location;
  final String? description;
  final int maxPersons;
  double distance;
  EventModel({
    required this.id,
    required this.createdBy,
    required this.createdAt,
    required this.imageUrls,
    required this.title,
    required this.dateTime,
    required this.location,
    this.description,
    required this.maxPersons,
    this.distance = 0,
  });

  EventModel copyWith({
    String? id,
    String? createdBy,
    DateTime? createdAt,
    List<String>? imageUrls,
    String? title,
    DateTime? dateTime,
    LocationModel? location,
    String? description,
    int? maxPersons,
  }) {
    return EventModel(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      imageUrls: imageUrls ?? this.imageUrls,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      description: description ?? this.description,
      maxPersons: maxPersons ?? this.maxPersons,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdBy': createdBy,
      // ignore: sdk_version_since
      'createdAt': Timestamp.fromDate(createdAt),
      'imageUrls': imageUrls,
      'title': title,
      'dateTime': Timestamp.fromDate(dateTime),
      'location': location.toMap(),
      'description': description,
      'maxPersons': maxPersons,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] as String,
      createdBy: map['createdBy'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      imageUrls: List<String>.from((map['imageUrls'] as List<dynamic>).map(
        (e) => e.toString(),
      )),
      title: map['title'] as String,
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      location: LocationModel.fromMap(map['location'] as Map<String, dynamic>),
      description:
          map['description'] != null ? map['description'] as String : null,
      maxPersons: map['maxPersons'] as int? ?? 0,
    );
  }
  @override
  String toString() {
    return 'EventModel(id: $id, createdBy: $createdBy, createdAt: $createdAt, imageUrls: $imageUrls, title: $title, dateTime: $dateTime, location: $location, description: $description, maxPersons: $maxPersons)';
  }

  @override
  bool operator ==(covariant EventModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.createdBy == createdBy &&
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
        createdBy.hashCode ^
        createdAt.hashCode ^
        imageUrls.hashCode ^
        title.hashCode ^
        dateTime.hashCode ^
        location.hashCode ^
        maxPersons.hashCode ^
        description.hashCode;
  }
}
