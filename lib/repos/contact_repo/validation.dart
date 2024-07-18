// Project: 	   muutsch
// File:    	   validation
// Path:    	   lib/repos/contact_repo/validation.dart
// Author:       Ali Akbar
// Date:        18-07-24 16:51:17 -- Thursday
// Description:

import 'package:musch/exceptions/data_exceptions.dart';

class ContactValidation {
  static Future<void> validate(
      {required String name,
      required String email,
      required String message}) async {
    if (name == "") {
      throw DataExceptionRequiredField(message: "Please enter your name.");
    }

    if (email == "") {
      throw DataExceptionRequiredField(message: "Please enter your email.");
    }

    if (message == "") {
      throw DataExceptionRequiredField(message: "Please enter your message.");
    }
  }
}
