// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// Project: 	   muutsch
// File:    	   privacy_model
// Path:    	   lib/models/privacy_model.dart
// Author:       Ali Akbar
// Date:        18-07-24 18:11:23 -- Thursday
// Description:

class PrivacyModel {
  final String uuid;
  final String heading;
  final String content;
  PrivacyModel({
    required this.uuid,
    required this.heading,
    required this.content,
  });

  PrivacyModel copyWith({
    String? uuid,
    String? heading,
    String? content,
  }) {
    return PrivacyModel(
      uuid: uuid ?? this.uuid,
      heading: heading ?? this.heading,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'heading': heading,
      'content': content,
    };
  }

  factory PrivacyModel.fromMap(Map<String, dynamic> map) {
    return PrivacyModel(
      uuid: map['uuid'] as String,
      heading: map['heading'] as String,
      content: map['content'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PrivacyModel.fromJson(String source) =>
      PrivacyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PrivacyModel(uuid: $uuid, heading: $heading, content: $content)';

  @override
  bool operator ==(covariant PrivacyModel other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid &&
        other.heading == heading &&
        other.content == content;
  }

  @override
  int get hashCode => uuid.hashCode ^ heading.hashCode ^ content.hashCode;
}
