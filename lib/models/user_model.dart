// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'child_model.dart';
import 'location_model.dart';

// ignore: dangling_library_doc_comments
/// Project: 	   playtogethher
/// File:    	   user_model
/// Path:    	   lib/model/user_model.dart
/// Author:       Ali Akbar
/// Date:        08-03-24 14:13:23 -- Friday
/// Description:

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String avatar;
  final DateTime createdAt;
  final String? role;
  final bool? isActived;
  final int? numberOfChildren;
  final List<ChildModel>? children;
  final LocationModel? location;
  final List<String>? interests;
  final String? bio;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.avatar,
    required this.createdAt,
    this.role,
    this.isActived,
    this.children,
    this.location,
    this.numberOfChildren,
    this.interests,
    this.bio,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? avatar,
    String? phoneNumber,
    String? apartment,
    String? address,
    DateTime? createdAt,
    bool? isActived,
    int? numOfChildren,
    List<ChildModel>? children,
    LocationModel? location,
    List<String>? interests,
    String? bio,
    String? role,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isActived: isActived ?? this.isActived,
      children: children ?? this.children,
      numberOfChildren: numOfChildren ?? numberOfChildren,
      location: location ?? this.location,
      interests: interests ?? this.interests,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toMap({bool isFromJson = false}) {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'avatar': avatar,
      'createdAt': isFromJson
          ? createdAt.millisecondsSinceEpoch
          : Timestamp.fromDate(createdAt),
      'isActived': true,
      'numOfChildren': numberOfChildren,
      'role': role,
      'location': location?.toMap(),
      'children': children?.map((e) => e.toMap()).toList(),
      'interests': interests,
      'bio': bio,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map,
      {bool isFromJson = false}) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String? ?? "",
      email: map['email'] as String? ?? "",
      avatar: map['avatar'] as String? ?? "",
      role: map['role'] as String?,
      numberOfChildren: map['numOfChildren'] as int? ?? 0,
      location: map['location'] != null
          ? LocationModel.fromMap((map['location']))
          : null,
      children: map['children'] != null
          ? (map['children'] as List<dynamic>)
              .map((e) => ChildModel.fromMap(e))
              .toList()
          : null,
      createdAt: isFromJson
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : (map['createdAt'] as Timestamp).toDate(),
      isActived: (map['isActived'] as bool? ?? false),
      interests: map['interests'] != null
          ? (map['interests'] as List<dynamic>)
              .map((e) => e.toString())
              .toList()
          : null,
      bio: map['bio'] as String?,
    );
  }

  String toJson() => json.encode(toMap(isFromJson: true));

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>,
          isFromJson: true);
  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, avatar: $avatar, createdAt: $createdAt, isActived: $isActived, numberOfChildren: $numberOfChildren, children: ${children.toString()}, location: ${location.toString()}, interests: $interests, bio:$bio)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.avatar == avatar &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        avatar.hashCode ^
        createdAt.hashCode;
  }
}
