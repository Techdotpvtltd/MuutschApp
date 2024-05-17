// Project: 	   muutsch
// File:    	   friend_state
// Path:    	   lib/blocs/friend/friend_state.dart
// Author:       Ali Akbar
// Date:        17-05-24 14:18:04 -- Friday
// Description:

import '../../exceptions/app_exceptions.dart';
import '../../models/friend_model.dart';

abstract class FriendState {
  final bool isLoading;

  FriendState({this.isLoading = false});
}

/// InitialState
class FriendStateInitial extends FriendState {}

// ===========================Send Request States================================
class FriendStateSending extends FriendState {
  FriendStateSending({super.isLoading = true});
}

class FriendStateSendFailure extends FriendState {
  final AppException exception;

  FriendStateSendFailure({required this.exception});
}

class FriendStateSent extends FriendState {
  final FriendModel friend;

  FriendStateSent({required this.friend});
}
