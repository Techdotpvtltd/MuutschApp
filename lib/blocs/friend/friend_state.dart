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

// ===========================Fetch Friend States================================

class FriendStateFetching extends FriendState {
  FriendStateFetching({super.isLoading = true});
}

class FriendStateFetchFailure extends FriendState {
  final AppException exception;
  FriendStateFetchFailure({required this.exception});
}

class FriendStateDataAdded extends FriendState {}

class FriendStateDataUpdated extends FriendState {
  final FriendModel friend;

  FriendStateDataUpdated({required this.friend});
}

class FriendStateDataRemoved extends FriendState {
  final FriendModel friend;

  FriendStateDataRemoved({required this.friend});
}

class FriendStateFetchedAll extends FriendState {}

class FriendStateFetchedPendingRequests extends FriendState {
  final List<FriendModel> friends;

  FriendStateFetchedPendingRequests({required this.friends});
}

// ===========================Get Friend State================================
class FriendStateGot extends FriendState {
  final FriendModel friend;

  FriendStateGot({required this.friend});
}

// ===========================Friend States================================

class FriendStateAccepting extends FriendState {
  FriendStateAccepting({super.isLoading = true});
}

class FriendStateAcceptFailure extends FriendState {
  final AppException exception;

  FriendStateAcceptFailure({required this.exception});
}

class FriendStateAccepted extends FriendState {
  final FriendModel frined;

  FriendStateAccepted({required this.frined});
}

// ===========================Removing or Reject Friend States================================

class FriendStateRejecting extends FriendState {
  FriendStateRejecting({super.isLoading = true});
}

class FriendStateRejectFailure extends FriendState {
  final AppException exception;

  FriendStateRejectFailure({required this.exception});
}

class FriendStateRejected extends FriendState {}

class FriendStateRemoving extends FriendState {
  FriendStateRemoving({super.isLoading = true});
}

class FriendStateRemoveFailure extends FriendState {
  final AppException exception;

  FriendStateRemoveFailure({required this.exception});
}

class FriendStateRemoved extends FriendState {}
