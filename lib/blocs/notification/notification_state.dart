// Project: 	   muutsch
// File:    	   notification_state
// Path:    	   lib/blocs/notification/notification_state.dart
// Author:       Ali Akbar
// Date:        29-05-24 17:04:23 -- Wednesday
// Description:

import '../../exceptions/app_exceptions.dart';
import '../../models/notification_model.dart';

abstract class NotificationState {
  final bool isLoading;

  NotificationState({this.isLoading = false});
}

class NotificationStateInitial extends NotificationState {}

// ===========================Save Notification States================================

class NotificationStateSaving extends NotificationState {
  NotificationStateSaving({super.isLoading = true});
}

class NotificationStateSaveFailure extends NotificationState {
  final AppException exception;

  NotificationStateSaveFailure({required this.exception});
}

class NotificationStateSaved extends NotificationState {}

// ===========================Fetch Notification States================================

class NotificationStateFetching extends NotificationState {
  NotificationStateFetching({super.isLoading = true});
}

class NotificationStateFetchFailure extends NotificationState {
  final AppException exception;

  NotificationStateFetchFailure({required this.exception});
}

class NotificationStateFetched extends NotificationState {
  final List<NotificationModel> notifications;

  NotificationStateFetched({required this.notifications});
}
