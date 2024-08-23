// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

// Project: 	   muutsche_admin_panel
// File:    	   interest_model
// Path:    	   lib/models/interest_model.dart
// Author:       Ali Akbar
// Date:        15-07-24 17:35:11 -- Monday
// Description:

class InterestModel {
  final String uuid;
  final String name;
  final DateTime createdAt;
  InterestModel({
    required this.uuid,
    required this.name,
    required this.createdAt,
  });

  factory InterestModel.fromMap(Map<String, dynamic> map) {
    return InterestModel(
      uuid: map['uuid'] as String,
      name: map['name'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
  @override
  String toString() =>
      'InterestModel(uuid: $uuid, name: $name, createdAt: $createdAt)';
}
