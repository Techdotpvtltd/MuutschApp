// Project: 	   muutsche_admin_panel
// File:    	   contact_repo_impl
// Path:    	   lib/repos/contact_repo/contact_repo_impl.dart
// Author:       Ali Akbar
// Date:        18-07-24 12:57:46 -- Thursday
// Description:

import 'package:musch/exceptions/exception_parsing.dart';
import 'package:musch/repos/contact_repo/validation.dart';
import 'package:musch/repos/user_repo.dart';
import 'package:musch/utils/constants/firebase_collections.dart';
import 'package:musch/web_services/firestore_services.dart';

import '../../models/contact_us_model.dart';
import 'contact_repo_interface.dart';

class ContactRepo implements ContactRepoInterface {
  @override
  Future<void> save({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      await ContactValidation.validate(
          name: name, email: email, message: message);
      final ContactUsModel model = ContactUsModel(
        uuid: '',
        username: name,
        email: email,
        message: message,
        avatar: UserRepo().currentUser.avatar,
        createdAt: DateTime.now(),
      );

      await FirestoreService().saveWithSpecificIdFiled(
          path: FIREBASE_COLLECTION_CONTACTS,
          data: model.toMap(),
          docIdFiled: 'uuid');
    } catch (e) {
      throw throwAppException(e: e);
    }
  }
}
