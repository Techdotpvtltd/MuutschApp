// Project: 	   muutsch
// File:    	   event_state
// Path:    	   lib/blocs/event/event_state.dart
// Author:       Ali Akbar
// Date:        14-05-24 15:31:39 -- Tuesday
// Description:

import '../../exceptions/app_exceptions.dart';
import '../../models/event_model.dart';

abstract class EventState {
  final bool isLoading;
  final String loadingText;

  EventState({this.isLoading = false, this.loadingText = ""});
}

/// initial State

class EventStateInitial extends EventState {}

// ===========================Create Event States================================

class EventStateUploadingImages extends EventState {
  EventStateUploadingImages({super.isLoading = true, super.loadingText});
}

class EventStateUploadImgaesFailure extends EventState {
  final AppException? exception;

  EventStateUploadImgaesFailure({this.exception, super.loadingText});
}

class EventStateUploadedImages extends EventState {
  EventStateUploadedImages({super.loadingText});
}

/// Create Event States
class EventStateCreating extends EventState {
  EventStateCreating({super.isLoading = true, super.loadingText});
}

class EventStateCreateFailure extends EventState {
  final AppException exception;

  EventStateCreateFailure({required this.exception});
}

class EventStateCreated extends EventState {
  final EventModel event;

  EventStateCreated({required this.event});
}

// ===========================Fetch Event States================================

class EventStateFetching extends EventState {
  EventStateFetching({super.isLoading = true});
}

class EventStateFetchFailure extends EventState {
  final AppException exception;
  EventStateFetchFailure({required this.exception});
}

class EventStateFetched extends EventState {}
