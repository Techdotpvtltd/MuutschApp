// ignore: dangling_library_doc_comments
import '../../models/child_model.dart';
import '../../models/location_model.dart';

/// Project: 	   playtogethher
/// File:    	   user_event
/// Path:    	   lib/blocs/user/user_event.dart
/// Author:       Ali Akbar
/// Date:        13-03-24 15:41:39 -- Wednesday
/// Description:
///

abstract class UserEvent {}

/// Update Profile Event
class UserEventUpdateProfile extends UserEvent {
  final String? avatar;
  final List<ChildModel>? children;
  final UserLocationModel? location;
  final int? numberOfChildren;
  final List<String>? interests;

  UserEventUpdateProfile({
    this.children,
    this.location,
    this.numberOfChildren,
    this.avatar,
    this.interests,
  });
}
