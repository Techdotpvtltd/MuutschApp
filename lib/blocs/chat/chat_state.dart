// Project: 	   muutsch
// File:    	   chat_state
// Path:    	   lib/blocs/chat/chat_state.dart
// Author:       Ali Akbar
// Date:        31-05-24 13:26:54 -- Friday
// Description:

import '../../exceptions/app_exceptions.dart';
import '../../models/chat_model.dart';

abstract class ChatState {
  final bool isLoading;

  ChatState({this.isLoading = false});
}

/// initialState
class ChatStateInitial extends ChatState {}

// ===========================Creating Chat================================
class ChatStateCreating extends ChatState {
  ChatStateCreating({super.isLoading = true});
}

class ChatStateCreateFailure extends ChatState {
  final AppException exception;
  ChatStateCreateFailure({required this.exception});
}

class ChatStateCreated extends ChatState {
  final ChatModel chat;

  ChatStateCreated({required this.chat});
}

// ===========================Fetch all chats================================
class ChatStateFetchingAll extends ChatState {
  ChatStateFetchingAll({super.isLoading = true});
}

class ChatStateFetchAllFailure extends ChatState {
  final AppException exception;
  ChatStateFetchAllFailure({required this.exception});
}

class ChatStateFetchedAll extends ChatState {}

// ===========================Fetch Single Chat================================
class ChatStateFetching extends ChatState {
  ChatStateFetching({super.isLoading = true});
}

class ChatStateFetchFailure extends ChatState {
  final AppException exception;
  ChatStateFetchFailure({required this.exception});
}

class ChatStateFetched extends ChatState {
  final ChatModel? chat;

  ChatStateFetched({this.chat});
}

// ===========================Joined================================
class ChatStateJoining extends ChatState {
  ChatStateJoining({super.isLoading = true});
}

class ChatStateJoinFailure extends ChatState {
  final AppException exception;
  ChatStateJoinFailure({required this.exception});
}

class ChatStateJoined extends ChatState {}

// ===========================Group Chat Status Visibility================================

class ChatStateUpdatingGroupStatus extends ChatState {
  ChatStateUpdatingGroupStatus({super.isLoading = false});
}

class ChatStateUpdateGroupStatusFailure extends ChatState {
  final AppException exception;

  ChatStateUpdateGroupStatusFailure({required this.exception});
}

class ChatStateUpdatedStatus extends ChatState {
  final bool status;
  final String eventId;

  ChatStateUpdatedStatus({required this.eventId, required this.status});
}

// ===========================Remove Member Chat================================

class ChatStateMemberRemoved extends ChatState {
  final String memeberId;

  ChatStateMemberRemoved({required this.memeberId});
}
