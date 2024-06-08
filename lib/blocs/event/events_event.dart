// Project: 	   muutsch
// File:    	   event_event
// Path:    	   lib/blocs/event/events_event.dart
// Author:       Ali Akbar
// Date:        14-05-24 15:42:35 -- Tuesday
// Description:

import 'package:flutter/material.dart';

import '../../models/event_model.dart';
import '../../models/location_model.dart';

abstract class EventsEvent {}

/// Create Event Eveny

class EventsEventCreate extends EventsEvent {
  final List<String> imageUrls;
  final String title;
  final DateTime? date;
  final TimeOfDay? time;
  final LocationModel? eventLocation;
  final String? description;
  final String? maxPersons;

  EventsEventCreate({
    required this.imageUrls,
    required this.title,
    this.date,
    this.time,
    this.eventLocation,
    this.description,
    this.maxPersons,
  });
}

/// Fetch Events

class EventsEventFetchCurrentLocation extends EventsEvent {}

class EventsEventFetchOwn extends EventsEvent {}

class EventsEventFetchAll extends EventsEvent {}

class EventsEventFilter extends EventsEvent {
  final String? searchText;
  final LocationModel? location;
  final double? minDistance;
  final double? maxDistance;

  EventsEventFilter({
    this.searchText,
    this.location,
    this.minDistance,
    this.maxDistance,
  });
}

/// Filter Events

class EventsEventApplyFilter extends EventsEvent {
  final String? searchText;
  final LocationModel? location;
  final RangeValues? values;

  EventsEventApplyFilter({this.searchText, this.location, this.values});
}

class EventsEventClearFilter extends EventsEvent {}

/// Deleting Event
class EventsEventDelete extends EventsEvent {
  final String eventId;

  EventsEventDelete({required this.eventId});
}

/// Update Events
class EventsEventUpdate extends EventsEvent {
  final List<String> imageUrls;
  final String title;
  final DateTime? date;
  final TimeOfDay? time;
  final LocationModel? eventLocation;
  final String? description;
  final String? maxPersons;
  final String eventId;
  final EventModel oldEvent;
  EventsEventUpdate({
    required this.imageUrls,
    required this.title,
    required this.date,
    required this.time,
    required this.eventLocation,
    required this.description,
    required this.maxPersons,
    required this.eventId,
    required this.oldEvent,
  });
}

/// Join Event Event

class EventsEventJoin extends EventsEvent {
  final String eventId;

  EventsEventJoin({required this.eventId});
}

/// Clear And UnSubscribe All events
class EventsEventClearAndUnSubscribe extends EventsEvent {}
