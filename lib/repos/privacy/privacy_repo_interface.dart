// Project: 	   muutsch
// File:    	   privacy_repo
// Path:    	   lib/repos/privacy_repo.dart
// Author:       Ali Akbar
// Date:        18-07-24 18:14:20 -- Thursday
// Description:

import 'package:musch/models/privacy_model.dart';

abstract class PrivacyRepoInterface {
  Future<List<PrivacyModel>> fetch();
}
