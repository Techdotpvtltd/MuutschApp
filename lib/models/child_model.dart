// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// Project: 	   muutsch
// File:    	   child_model
// Path:    	   lib/models/child_model.dart
// Author:       Ali Akbar
// Date:        10-05-24 18:25:12 -- Friday
// Description:

class ChildModel {
  final DateTime dateOfBirth;
  final String gender;
  ChildModel({
    required this.dateOfBirth,
    required this.gender,
  });

  ChildModel copyWith({
    DateTime? dateOfBirth,
    String? gender,
  }) {
    return ChildModel(
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // ignore: sdk_version_since
      'dateOfBirth': DateTime.timestamp(),
      'gender': gender,
    };
  }

  factory ChildModel.fromMap(Map<String, dynamic> map) {
    return ChildModel(
      dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
      gender: map['gender'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChildModel.fromJson(String source) =>
      ChildModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ChildModel(dateOfBirth: $dateOfBirth, gender: $gender)';

  @override
  bool operator ==(covariant ChildModel other) {
    if (identical(this, other)) return true;

    return other.dateOfBirth == dateOfBirth && other.gender == gender;
  }

  @override
  int get hashCode => dateOfBirth.hashCode ^ gender.hashCode;
}
