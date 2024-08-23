// Project: 	   muutsch
// File:    	   notification_bloc
// Path:    	   lib/blocs/notification/notification_bloc.dart
// Author:       Ali Akbar
// Date:        29-05-24 17:09:14 -- Wednesday
// Description:

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musch/blocs/notification/notification_event.dart';
import 'package:musch/services/local_storage_services/local_storage_services.dart';

import '../../exceptions/app_exceptions.dart';
import '../../models/notification_model.dart';
import '../../repos/notification_repo.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  List<NotificationModel> notifications = [];
  NotificationBloc() : super(NotificationStateInitial()) {
    final List<String> readableNotificationIds = [];

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
            type: event.type,
            data: null,
            avatar: '',
          );
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
          notifications = await NotificationRepo().fetech();
          final List<String> ids =
              await LocalStorageServices().getNotificationIds();
          for (final notifcation in notifications) {
            if (!ids.contains(notifcation.uuid)) {
              readableNotificationIds.add(notifcation.uuid);
            }
          }
          emit(NotificationStateFetched(notifications: notifications));
          emit(NotificationStateNewAvailable(
              isNew: readableNotificationIds.isNotEmpty));
        } on AppException catch (e) {
          emit(NotificationStateFetchFailure(exception: e));
        }
      },
    );

    /// Mark readable
    on<NotificationEventMarkReadable>(
      (event, emit) async {
        emit(NotificationStateNewAvailable(isNew: false));
        await LocalStorageServices()
            .saveNotificationIds(ids: readableNotificationIds);
        readableNotificationIds.clear();
      },
    );

    /// onRecievedPush
    on<NotificationEventOnReceivedPushNotification>(
      (event, emit) {
        log("Called in Nloc");

        emit(NotificationStateOnReceivedPush(message: event.message));
      },
    );

    /// On Delete Event Trigger
    on<NotificationEventDelete>(
      (event, emit) async {
        NotificationRepo().delete(notificationId: event.notificationId);

        final int index =
            notifications.indexWhere((e) => e.uuid == event.notificationId);
        if (index > -1) {
          notifications.removeAt(index);
        }

        emit(NotificationStateDeleted(uuid: event.notificationId));
      },
    );
  }
}
