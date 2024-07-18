// Project: 	   muutsch
// File:    	   privacy_repo_impl
// Path:    	   lib/repos/privacy/privacy_repo_impl.dart
// Author:       Ali Akbar
// Date:        18-07-24 18:16:00 -- Thursday
// Description:

import 'package:musch/exceptions/exception_parsing.dart';
import 'package:musch/models/privacy_model.dart';
import 'package:musch/repos/privacy/privacy_repo_interface.dart';
import 'package:musch/utils/constants/firebase_collections.dart';
import 'package:musch/web_services/firestore_services.dart';
import 'package:musch/web_services/query_model.dart';

class PrivacyRepo implements PrivacyRepoInterface {
  @override
  Future<List<PrivacyModel>> fetch() async {
    try {
      final List<Map<String, dynamic>> data =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_AGREEMENTS,
        queries: [
          QueryModel(field: "createdAt", value: true, type: QueryType.isEqual)
        ],
      );

      return data.map((e) => PrivacyModel.fromMap(e)).toList();
    } catch (e) {
      throw throwAppException(e: e);
    }
  }
}
