// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// Project: 	   muutsch
// File:    	   light_user_model
// Path:    	   lib/models/light_user_model.dart
// Author:       Ali Akbar
// Date:        31-05-24 12:04:52 -- Friday
// Description:

class LightUserModel {
  final String uid;
  final String name;
  final String avatarUrl;
  LightUserModel({
    required this.uid,
    required this.name,
    required this.avatarUrl,
  });

  LightUserModel copyWith({
    String? uid,
    String? name,
    String? avatarUrl,
  }) {
    return LightUserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'avatarUrl': avatarUrl,
    };
  }

  factory LightUserModel.fromMap(Map<String, dynamic> map) {
    return LightUserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      avatarUrl: map['avatarUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LightUserModel.fromJson(String source) =>
      LightUserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LightUserModel(uid: $uid, name: $name, avatarUrl: $avatarUrl)';

  @override
  bool operator ==(covariant LightUserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode => uid.hashCode ^ name.hashCode ^ avatarUrl.hashCode;
}
