// Project: 	   muutsch
// File:    	   event_state
// Path:    	   lib/blocs/event/event_state.dart
// Author:       Ali Akbar
// Date:        14-05-24 15:31:39 -- Tuesday
// Description:

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../exceptions/app_exceptions.dart';
import '../../models/event_model.dart';
import '../../models/join_event_model.dart';
import '../../models/location_model.dart';

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

class EventStateOwnFetching extends EventState {
  EventStateOwnFetching({super.isLoading = true});
}

class EventStateOwnFetchFailure extends EventState {
  final AppException exception;
  EventStateOwnFetchFailure({required this.exception});
}

class EventStateOwnFetched extends EventState {
  final List<EventModel> events;

  EventStateOwnFetched({required this.events});
}

///                     ========================================
class EventStateFetching extends EventState {
  EventStateFetching({super.isLoading = true});
}

class EventStateFetchFailure extends EventState {
  final AppException exception;
  EventStateFetchFailure({required this.exception});
}

class EventStateFetched extends EventState {
  final List<EventModel> events;

  EventStateFetched({required this.events});
}

class EventStateFetchedAll extends EventState {
  final List<EventModel> events;

  EventStateFetchedAll({required this.events});
}

class EventStateFetchedFiltered extends EventState {
  final List<EventModel> events;

  EventStateFetchedFiltered({required this.events});
}

// ===========================Delete Event States================================

class EventStateDeteing extends EventState {
  EventStateDeteing({super.isLoading = true});
}

class EventStateDeleteFailure extends EventState {
  final AppException exception;
  EventStateDeleteFailure({required this.exception});
}

class EventStateDeleted extends EventState {
  final String eventId;

  EventStateDeleted({required this.eventId});
}

// ===========================Update Event States================================

class EventStateUpdating extends EventState {
  EventStateUpdating({super.isLoading = true, super.loadingText});
}

class EventStateUpdateFailure extends EventState {
  final AppException exception;

  EventStateUpdateFailure({required this.exception});
}

class EventStateUpdated extends EventState {
  final EventModel updatedEvent;

  EventStateUpdated({required this.updatedEvent});
}

// ===========================Filter States================================

class EventStateApplyFilter extends EventState {
  final String? searchText;
  final LocationModel? location;
  final RangeValues? values;

  EventStateApplyFilter({this.searchText, this.location, this.values});
}

class EventStateClearFilter extends EventState {}

// ===========================Location Fetch Event================================
class EventStateFetchedCurrentLocation extends EventState {
  final Position? position;

  EventStateFetchedCurrentLocation({this.position});
}

// ===========================Join Event States================================
class EventStateJoining extends EventState {
  final String eventId;
  EventStateJoining(
      {super.isLoading = true, super.loadingText, required this.eventId});
}

class EventStateJoinFailure extends EventState {
  final AppException exception;

  EventStateJoinFailure({required this.exception});
}

class EventStateJoined extends EventState {
  final JoinEventModel joinModel;

  EventStateJoined({required this.joinModel});
}

/// Fetch Info
class EventStateFetchJoining extends EventState {
  final String eventId;
  EventStateFetchJoining(
      {super.isLoading = true, super.loadingText, required this.eventId});
}

class EventStateFetchJoinFailure extends EventState {
  final AppException exception;

  EventStateFetchJoinFailure({required this.exception});
}

class EventStateFetchJoined extends EventState {
  final List<JoinEventModel> joinData;

  EventStateFetchJoined({required this.joinData});
}
