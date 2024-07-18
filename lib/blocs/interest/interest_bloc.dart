// Project: 	   muutsche_admin_panel
// File:    	   interest_bloc
// Path:    	   lib/blocs/interest/interest_bloc.dart
// Author:       Ali Akbar
// Date:        15-07-24 18:08:07 -- Monday
// Description:

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musch/models/interest_model.dart';

import '../../exceptions/app_exceptions.dart';
import '../../repos/interest_repo.dart';
import 'interest_event.dart';
import 'interest_state.dart';

class InterestBloc extends Bloc<InterestEvent, InterestState> {
  InterestBloc() : super(InterestStateInitial()) {
    /// on Fetch All Event Trigger
    on<InterestEventFetchAll>(
      (event, emit) async {
        try {
          emit(InterestStateFetching());
          final List<InterestModel> interests = await InterestRepo().fetchAll();
          emit(InterestStateFetched(interests: interests));
        } on AppException catch (e) {
          emit(InterestStateFetchFailure(exception: e));
        }
      },
    );
  }
}
