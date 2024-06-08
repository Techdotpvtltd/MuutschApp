// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// Project: 	   muutsch
// File:    	   light_user_model
// Path:    	   lib/models/light_user_model.dart
// Author:       Ali Akbar
// Date:        31-05-24 12:04:52 -- Friday
// Description:

class OtherUserModel {
  final String uid;
  final String name;
  final String avatarUrl;
  final DateTime? createdAt;
  final String? about;
  OtherUserModel({
    required this.uid,
    required this.name,
    required this.avatarUrl,
    this.about,
    this.createdAt,
  });

  OtherUserModel copyWith({
    String? uid,
    String? name,
    String? avatarUrl,
    String? about,
    DateTime? createdAt,
  }) {
    return OtherUserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      about: about ?? this.about,
      createdAt: createdAt ?? this.createdAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'avatarUrl': avatarUrl,
      'about': about,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  factory OtherUserModel.fromMap(Map<String, dynamic> map) {
    return OtherUserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      about: map['about'] as String? ?? "",
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      avatarUrl: map['avatarUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OtherUserModel.fromJson(String source) =>
      OtherUserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LightUserModel(uid: $uid, name: $name, avatarUrl: $avatarUrl, about: $about, createdAt: $createdAt)';

  @override
  bool operator ==(covariant OtherUserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.about == about &&
        other.createdAt == createdAt &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode =>
      uid.hashCode ^
      name.hashCode ^
      avatarUrl.hashCode ^
      about.hashCode ^
      createdAt.hashCode;
}
