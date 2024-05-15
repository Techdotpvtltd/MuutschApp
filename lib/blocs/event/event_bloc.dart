// Project: 	   muutsch
// File:    	   event_bloc
// Path:    	   lib/blocs/event/event_bloc.dart
// Author:       Ali Akbar
// Date:        14-05-24 15:50:34 -- Tuesday
// Description:

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:place_picker/uuid.dart';

import '../../exceptions/app_exceptions.dart';
import '../../models/event_model.dart';
import '../../repos/event_repo.dart';
import '../../repos/user_repo.dart';
import '../../utils/utils.dart';
import 'event_state.dart';
import 'events_event.dart';

class EventBloc extends Bloc<EventsEvent, EventState> {
  EventBloc() : super(EventStateInitial()) {
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
          emit(EventStateFetching());
          final List<EventModel> events =
              await EventRepo().fetchEvents(withUserId: userId);
          emit(EventStateFetched(events: events));
        } on AppException catch (e) {
          emit(EventStateFetchFailure(exception: e));
        }
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
        } on AppException catch (e) {
          emit(EventStateUpdateFailure(exception: e));
        }
      },
    );
  }
}
