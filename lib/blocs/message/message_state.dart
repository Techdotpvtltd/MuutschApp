import '../../exceptions/app_exceptions.dart';

/// Project: 	   wasteapp
/// File:    	   message_state
/// Path:    	   lib/blocs/message/message_state.dart
/// Author:       Ali Akbar
/// Date:        21-03-24 14:42:02 -- Thursday
/// Description:

abstract class MessageState {
  final bool isLoading;
  final String loadingText;

  MessageState({this.isLoading = false, this.loadingText = "Processig..."});
}

// Initial State
class MessageStateInitial extends MessageState {}

// ===========================Fetch Messages States================================
class MessageStateFetching extends MessageState {
  MessageStateFetching(
      {super.isLoading = true, super.loadingText = "Fetching..."});
}

class MessageStateFetchFailure extends MessageState {
  final AppException exception;

  MessageStateFetchFailure({required this.exception});
}

class MessageStateFetched extends MessageState {}

// ===========================Send Message States================================
class MessageStateSending extends MessageState {
  MessageStateSending(
      {super.isLoading = true, super.loadingText = "Sending..."});
}

class MessageStateSendFailure extends MessageState {
  final AppException exception;

  MessageStateSendFailure({required this.exception});
}

class MessageStateSent extends MessageState {}

class MessageStatePrepareToSend extends MessageState {}

class MessageStateNew extends MessageState {
  final bool isNew;

  MessageStateNew({required this.isNew});
}
