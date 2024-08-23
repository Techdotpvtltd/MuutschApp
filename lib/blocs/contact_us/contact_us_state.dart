// Project: 	   muutsch
// File:    	   contact_us._state
// Path:    	   lib/blocs/contact_us/contact_us._state.dart
// Author:       Ali Akbar
// Date:        18-07-24 16:43:54 -- Thursday
// Description:

import 'package:musch/exceptions/app_exceptions.dart';

abstract class ContactUsState {
  final bool isLoading;

  ContactUsState({this.isLoading = false});
}

/// initial State
class ContactStateInitial extends ContactUsState {}

// ===========================Send Contact State================================

class ContactStateSending extends ContactUsState {
  ContactStateSending({super.isLoading = true});
}

class ContactStateSent extends ContactUsState {}

class ContactStateSendFailure extends ContactUsState {
  final AppException exception;

  ContactStateSendFailure({required this.exception});
}
