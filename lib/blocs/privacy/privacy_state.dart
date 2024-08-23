// Project: 	   muutsch
// File:    	   privacy_state
// Path:    	   lib/blocs/privacy/privacy_state.dart
// Author:       Ali Akbar
// Date:        18-07-24 18:19:30 -- Thursday
// Description:

import 'package:musch/exceptions/app_exceptions.dart';

import '../../models/privacy_model.dart';

abstract class PrivacyState {
  final bool isLoading;

  PrivacyState({this.isLoading = false});
}

/// Initial State
class PrivacyStateInitial extends PrivacyState {}
// ===========================Fetch All The Privacy================================

class PrivacyStateFetching extends PrivacyState {
  PrivacyStateFetching({super.isLoading = true});
}

class PrivacyStateFetchFailure extends PrivacyState {
  final AppException exception;

  PrivacyStateFetchFailure({required this.exception});
}

class PrivacyStateFetched extends PrivacyState {
  final List<PrivacyModel> privacies;

  PrivacyStateFetched({required this.privacies});
}
