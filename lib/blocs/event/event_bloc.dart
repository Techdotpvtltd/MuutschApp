// Project: 	   muutsch
// File:    	   event_bloc
// Path:    	   lib/blocs/event/event_bloc.dart
// Author:       Ali Akbar
// Date:        14-05-24 15:50:34 -- Tuesday
// Description:

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:place_picker/uuid.dart';

import '../../exceptions/app_exceptions.dart';
import '../../models/event_model.dart';
import '../../models/join_event_model.dart';
import '../../repos/event_repo.dart';
import '../../repos/user_repo.dart';
import '../../services/notification_services/fire_notification.dart';
import '../../services/notification_services/push_notification_services.dart';
import '../../utils/constants/constants.dart';
import '../../utils/helping_methods.dart';
import '../../utils/utils.dart';
import 'event_state.dart';
import 'events_event.dart';

class EventBloc extends Bloc<EventsEvent, EventState> {
  final List<EventModel> events = [];
  Position? position;

  EventBloc() : super(EventStateInitial()) {
    /// Fetch Current Location
    on<EventsEventFetchCurrentLocation>(
      (event, emit) async {
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        emit(EventStateFetchedCurrentLocation(position: position));
      },
    );

    /// Create Events
    on<EventsEventCreate>(
      (event, emit) async {
        try {
          final String userId = UserRepo().currentUser.uid;
          final String eventId = Uuid().generateV4();
          final List<String> uploadedImageUrls = [];
          for (int i = 0; i < event.imageUrls.length; i++) {
            emit(EventStateUploadingImages(loadingText: "Uploading image $i"));
            final String? downloadedUrl = await EventRepo()
                .uploadImage(imageUrl: event.imageUrls[i], eventId: eventId);
            if (downloadedUrl != null) {
              uploadedImageUrls.add(downloadedUrl);
              emit(EventStateUploadedImages(loadingText: "Uploaded image $i"));
              continue;
            }
          }

          final DateTime? mergedDateTime =
              Util.mergeDateTime(dateTime: event.date, time: event.time);
          emit(EventStateCreating(loadingText: 'Ready Event...'));
          final EventModel model = await EventRepo().createEvent(
              eventTitle: event.title,
              imageUrls: uploadedImageUrls,
              dateTime: mergedDateTime,
              maxPersons: event.maxPersons,
              description: event.description,
              location: event.eventLocation,
              userId: userId,
              uuid: eventId);
          emit(EventStateCreated(event: model));
        } on AppException catch (e) {
          emit(EventStateCreateFailure(exception: e));
        }
      },
    );

    /// Fetch Own Event

    on<EventsEventFetchOwn>(
      (event, emit) async {
        try {
          final String userId = UserRepo().currentUser.uid;
          emit(EventStateOwnFetching());
          final List<EventModel> events =
              await EventRepo().fetchEventsWith(withUserId: userId);
          emit(EventStateOwnFetched(events: events));
        } on AppException catch (e) {
          emit(EventStateOwnFetchFailure(exception: e));
        }
      },
    );

    /// Filter Events
    on<EventsEventFilter>(
      (event, emit) {
        List<EventModel> filteredEvents = List.from(events);
        if (event.searchText != null) {
          filteredEvents = filteredEvents
              .where((element) => element.title
                  .toLowerCase()
                  .contains(event.searchText!.toLowerCase()))
              .toList();
        }

        if (event.location != null) {
          filteredEvents = filteredEvents.where((element) {
            final double distance = (calculateDistance(
                aLat: event.location!.latitude,
                aLong: event.location!.longitude,
                bLat: element.location.latitude,
                bLong: element.location.longitude));
            return distance >= (event.minDistance ?? 0) &&
                distance <= (event.maxDistance ?? 50);
          }).toList();
        }
        emit(EventStateFetchedFiltered(events: filteredEvents));
      },
    );

    /// Delete Events Event
    on<EventsEventDelete>(
      (event, emit) async {
        try {
          emit(EventStateDeteing());
          await EventRepo().deleteEvent(eventId: event.eventId);
          emit(EventStateDeleted(eventId: event.eventId));
        } on AppException catch (e) {
          emit(EventStateDeleteFailure(exception: e));
        }
      },
    );

    /// Udpate Events Event
    on<EventsEventUpdate>(
      (event, emit) async {
        try {
          /// Already Uploaded File URLs
          final List<String> alreadyUploadedImageUrls = [];

          /// New Selected images File URLs
          final List<String> selectedImageUrls = [];
          for (final String url in event.imageUrls) {
            if (url.isURL) {
              alreadyUploadedImageUrls.add(url);
            } else {
              selectedImageUrls.add(url);
            }
          }
          for (int i = 0; i < selectedImageUrls.length; i++) {
            emit(EventStateUploadingImages(loadingText: "Uploading image $i"));
            final String? downloadedUrl = await EventRepo().uploadImage(
                imageUrl: event.imageUrls[i], eventId: event.eventId);
            if (downloadedUrl != null) {
              alreadyUploadedImageUrls.add(downloadedUrl);
              emit(EventStateUploadedImages(loadingText: "Uploaded image $i"));
              continue;
            }
          }

          ////////////////

          final DateTime? mergedDateTime =
              Util.mergeDateTime(dateTime: event.date, time: event.time);
          emit(EventStateUpdating(loadingText: "Updating Event..."));
          await EventRepo().updateEvent(
            eventTitle: event.title,
            imageUrls: alreadyUploadedImageUrls,
            dateTime: mergedDateTime,
            maxPersons: event.maxPersons,
            description: event.description,
            location: event.eventLocation,
            uuid: event.eventId,
          );
          final EventModel updatedEvent = event.oldEvent.copyWith(
            title: event.title,
            imageUrls: alreadyUploadedImageUrls,
            dateTime: mergedDateTime,
            maxPersons: int.tryParse(event.maxPersons ?? "0") ?? 0,
            description: event.description,
            location: event.eventLocation,
          );
          emit(EventStateUpdated(updatedEvent: updatedEvent));
          FireNotification().sendNotification(
              title: event.title,
              description: "Event has been updated",
              topic: "$PUSH_NOTIFICATION_EVENT_UPDATES${event.eventId}",
              type: 'events');
        } on AppException catch (e) {
          emit(EventStateUpdateFailure(exception: e));
        }
      },
    );

    /// Fetch All Data Event
    on<EventsEventFetchAll>(
      (event, emit) async {
        if (events.isNotEmpty) {
          /// Avoid call api if data is already fetched
          emit(EventStateFetched(events: events));
        } else {
          /// called api for first time
          emit(EventStateFetching());
          await EventRepo().fetchAllEvents(
            onError: (exception) {
              emit(EventStateFetchFailure(exception: exception));
            },
            onEventRecieved: (event) {
              final int index =
                  events.indexWhere((element) => element.id == event.id);
              if (index > -1) {
                events[index] = event;
              } else {
                events.add(event);
              }
              event.distance = calculateDistance(
                  aLat: position?.latitude ?? 0,
                  aLong: position?.longitude ?? 0,
                  bLat: event.location.latitude,
                  bLong: event.location.longitude);

              events.sort((a, b) => a.distance.compareTo(b.distance));
              emit(EventStateFetched(events: events));
            },
            onEventUpdated: (event) {
              final int index =
                  events.indexWhere((element) => element.id == event.id);
              if (index > -1) {
                events[index] = event;

                event.distance = calculateDistance(
                    aLat: position?.latitude ?? 0,
                    aLong: position?.longitude ?? 0,
                    bLat: event.location.latitude,
                    bLong: event.location.longitude);

                events.sort((a, b) => a.distance.compareTo(b.distance));
                emit(EventStateFetched(events: events));
              }
            },
            onEventDeleted: (event) {
              final int index =
                  events.indexWhere((element) => element.id == event.id);
              if (index > -1) {
                events.removeAt(index);
                emit(EventStateFetched(events: events));
              }
            },
            onAllGet: () {
              emit(EventStateFetchedAll(events: events));
            },
          );
        }
      },
    );

    /// Apply Filter Event
    on<EventsEventApplyFilter>(
      (event, emit) => emit(
        EventStateApplyFilter(
            searchText: event.searchText,
            location: event.location,
            values: event.values),
      ),
    );

    /// clear Filter Event
    on<EventsEventClearFilter>((event, emit) => emit(EventStateClearFilter()));

    /// Join Event Event
    on<EventsEventJoin>(
      (event, emit) async {
        try {
          emit(EventStateJoining(eventId: event.eventId));
          final JoinEventModel joinEvent =
              await EventRepo().joinEvent(eventId: event.eventId);
          emit(EventStateJoined(joinModel: joinEvent));
          FireNotification().sendNotification(
              title: events
                  .firstWhere((element) => element.id == event.eventId)
                  .title,
              description: "${UserRepo().currentUser.name} joined your event.",
              topic:
                  "$PUSH_NOTIFICATION_FRIEND_REQUEST${events.firstWhere((element) => element.id == event.eventId).createdBy}",
              type: 'events');
        } on AppException catch (e) {
          emit(EventStateJoinFailure(exception: e));
        }
      },
    );

    /// Fetch Join Event
    on<EventsEventFetchJoin>(
      (event, emit) async {
        try {
          emit(EventStateFetchJoining(eventId: event.eventId));
          final List<JoinEventModel> joinsModel =
              await EventRepo().fetchJoinEvent(eventId: event.eventId);
          emit(EventStateFetchJoined(joinData: joinsModel));
          for (final JoinEventModel event in joinsModel) {
            PushNotificationServices().subscribe(
                forTopic: "$PUSH_NOTIFICATION_EVENT_UPDATES${event.eventId}");
          }
        } on AppException catch (e) {
          emit(EventStateFetchJoinFailure(exception: e));
        }
      },
    );
  }
}
