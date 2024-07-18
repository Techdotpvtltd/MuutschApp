// Project: 	   muutsch
// File:    	   contact_us_bloc
// Path:    	   lib/blocs/contact_us/contact_us_bloc.dart
// Author:       Ali Akbar
// Date:        18-07-24 16:47:21 -- Thursday
// Description:

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musch/blocs/contact_us/contact_us_event.dart';
import 'package:musch/blocs/contact_us/contact_us_state.dart';
import 'package:musch/exceptions/app_exceptions.dart';
import 'package:musch/repos/contact_repo/contact_repo_impl.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  ContactUsBloc(super.initialState) {
    /// ON Send Contact us Event Trigger
    on<ContactEventSend>(
      (event, emit) async {
        try {
          emit(ContactStateSending());
          await ContactRepo().save(
              name: event.name, email: event.email, message: event.message);
          emit(ContactStateSent());
        } on AppException catch (e) {
          emit(ContactStateSendFailure(exception: e));
        }
      },
    );
  }
}
