// Project: 	   muutsch
// File:    	   friend_repo
// Path:    	   lib/repos/friend_repo.dart
// Author:       Ali Akbar
// Date:        17-05-24 14:01:27 -- Friday
// Description:

import 'dart:developer';

import '../exceptions/exception_parsing.dart';
import '../models/friend_model.dart';
import '../utils/constants/firebase_collections.dart';
import '../web_services/firestore_services.dart';
import 'user_repo.dart';

class FriendRepo {
  // ===========================API Methods================================

  Future<FriendModel> sendRequest({required String recieverId}) async {
    try {
      final String userId = UserRepo().currentUser.uid;
      final FriendModel model = FriendModel(
          uuid: "",
          senderId: userId,
          participants: [userId, recieverId],
          recieverId: recieverId,
          type: FriendType.request,
          requestSendTime: DateTime.now());
      final Map<String, dynamic> data = await FirestoreService()
          .saveWithSpecificIdFiled(
              path: FIREBASE_COLLECTION_FRIENDS,
              data: model.toMap(),
              docIdFiled: 'uuid');
      return FriendModel.fromMap(data);
    } catch (e) {
      log("[debug FriendSendRequest] $e");
      throw throwAppException(e: e);
    }
  }
}
