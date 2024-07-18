// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

// Project: 	   muutsche_admin_panel
// File:    	   contact_us_model
// Path:    	   lib/models/contact_us_model.dart
// Author:       Ali Akbar
// Date:        18-07-24 12:52:38 -- Thursday
// Description:

class ContactUsModel {
  final String uuid;
  final String username;
  final String email;
  final String message;
  final String avatar;
  final DateTime createdAt;
  ContactUsModel({
    required this.uuid,
    required this.username,
    required this.email,
    required this.message,
    required this.avatar,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'username': username,
      'avatar': avatar,
      'email': email,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  @override
  String toString() {
    return 'ContactUsModel(uuid: $uuid, username: $username, email: $email, message: $message, createdAt: $createdAt, avatar: $avatar)';
  }
}
