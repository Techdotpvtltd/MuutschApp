// Project: 	   muutsche_admin_panel
// File:    	   interest_state
// Path:    	   lib/blocs/interest/interest_state.dart
// Author:       Ali Akbar
// Date:        15-07-24 17:58:54 -- Monday
// Description:

import '../../exceptions/app_exceptions.dart';
import '../../models/interest_model.dart';

abstract class InterestState {
  final bool isLoading;

  InterestState({this.isLoading = false});
}

//// Initial State
class InterestStateInitial extends InterestState {}

// ===========================Fetch Interest States================================

class InterestStateFetching extends InterestState {
  InterestStateFetching({super.isLoading = true});
}

class InterestStateFetchFailure extends InterestState {
  final AppException exception;

  InterestStateFetchFailure({required this.exception});
}

class InterestStateFetched extends InterestState {
  final List<InterestModel> interests;

  InterestStateFetched({required this.interests});
}
