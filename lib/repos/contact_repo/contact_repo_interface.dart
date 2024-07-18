// Project: 	   muutsche_admin_panel
// File:    	   contact_repo
// Path:    	   lib/repos/contact_repo.dart
// Author:       Ali Akbar
// Date:        18-07-24 12:54:49 -- Thursday
// Description:

import '../../models/contact_us_model.dart';

abstract class ContactRepoInterface {
  Future<void> save({
    required String name,
    required String email,
    required String message,
  });
}
