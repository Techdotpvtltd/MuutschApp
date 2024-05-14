// Project: 	   muutsch
// File:    	   event_event
// Path:    	   lib/blocs/event/events_event.dart
// Author:       Ali Akbar
// Date:        14-05-24 15:42:35 -- Tuesday
// Description:

import 'package:flutter/material.dart';

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

class EventsEventFetch extends EventsEvent {
  final String byUserId;

  EventsEventFetch({required this.byUserId});
}
