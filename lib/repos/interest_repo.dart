// Project: 	   muutsche_admin_panel
// File:    	   interest_repo
// Path:    	   lib/repos/interest/interest_repo.dart
// Author:       Ali Akbar
// Date:        15-07-24 17:37:25 -- Monday
// Description:

import '../exceptions/exception_parsing.dart';
import '../models/interest_model.dart';
import '../utils/constants/firebase_collections.dart';
import '../web_services/firestore_services.dart';
import '../web_services/query_model.dart';

class InterestRepo {
  /// Delete Interest

  Future<List<InterestModel>> fetchAll() async {
    try {
      final List<Map<String, dynamic>> data =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_INTERESTS,
        queries: [
          QueryModel(field: "name", value: false, type: QueryType.orderBy),
        ],
      );
      return data.map((e) => InterestModel.fromMap(e)).toList();
    } catch (e) {
      throw throwAppException(e: e);
    }
  }
}
