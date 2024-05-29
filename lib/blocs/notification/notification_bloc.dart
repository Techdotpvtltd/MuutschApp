// Project: 	   muutsch
// File:    	   notification_bloc
// Path:    	   lib/blocs/notification/notification_bloc.dart
// Author:       Ali Akbar
// Date:        29-05-24 17:09:14 -- Wednesday
// Description:

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musch/blocs/notification/notification_event.dart';

import '../../exceptions/app_exceptions.dart';
import '../../models/notification_model.dart';
import '../../repos/notification_repo.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationStateInitial()) {
    /// on Save
    on<NotificationEventSave>(
      (event, emit) {
        try {
          emit(NotificationStateSaving());
          NotificationRepo().save(
              recieverId: event.receiverId,
              title: event.title,
              contentId: event.contentId,
              message: event.message,
              type: event.type);
          emit(NotificationStateSaved());
        } on AppException catch (e) {
          emit(NotificationStateSaveFailure(exception: e));
        }
      },
    );

    /// on Fetch
    on<NotificationEventFetch>(
      (event, emit) async {
        try {
          emit(NotificationStateFetching());
          final List<NotificationModel> notifications =
              await NotificationRepo().fetech();
          emit(NotificationStateFetched(notifications: notifications));
        } on AppException catch (e) {
          emit(NotificationStateFetchFailure(exception: e));
        }
      },
    );
  }
}
