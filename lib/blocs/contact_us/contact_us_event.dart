// Project: 	   muutsch
// File:    	   contact_us_event
// Path:    	   lib/blocs/contact_us/contact_us_event.dart
// Author:       Ali Akbar
// Date:        18-07-24 16:46:18 -- Thursday
// Description:

abstract class ContactUsEvent {}

/// Send Contact
class ContactEventSend extends ContactUsEvent {
  final String name;
  final String email;
  final String message;

  ContactEventSend(
      {required this.name, required this.email, required this.message});
}
