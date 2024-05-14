// Project: 	   muutsch
// File:    	   event_bloc
// Path:    	   lib/blocs/event/event_bloc.dart
// Author:       Ali Akbar
// Date:        14-05-24 15:50:34 -- Tuesday
// Description:

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:place_picker/uuid.dart';

import '../../exceptions/app_exceptions.dart';
import '../../models/event_model.dart';
import '../../repos/event_repo.dart';
import '../../repos/user_repo.dart';
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

          emit(EventStateCreating(loadingText: 'Ready Event...'));
          final EventModel model = await EventRepo().createEvent(
              eventTitle: event.title,
              imageUrls: uploadedImageUrls,
              userId: userId,
              uuid: eventId);
          emit(EventStateCreated(event: model));
        } on AppException catch (e) {
          emit(EventStateCreateFailure(exception: e));
        }
      },
    );
  }
}
