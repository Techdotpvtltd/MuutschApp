// Project: 	   muutsch
// File:    	   friend_repo
// Path:    	   lib/repos/friend_repo.dart
// Author:       Ali Akbar
// Date:        17-05-24 14:01:27 -- Friday
// Description:

import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../exceptions/app_exceptions.dart';
import '../exceptions/exception_parsing.dart';
import '../models/friend_model.dart';
import '../utils/constants/firebase_collections.dart';
import '../web_services/firestore_services.dart';
import '../web_services/query_model.dart';
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

  /// Fetch All Friends Request
  Future<void> fetchFriends({
    required Function(FriendModel) onAddedData,
    required Function(FriendModel) onUpdated,
    required Function(FriendModel) onDeleted,
    required Function(AppException) onError,
    required VoidCallback onAllGet,
  }) async {
    final String userId = UserRepo().currentUser.uid;
    await FirestoreService().fetchWithListener(
      collection: FIREBASE_COLLECTION_FRIENDS,
      onError: (e) {
        log("[debug FetchFriends] $e");
        onError(throwAppException(e: e));
      },
      onAdded: (data) {
        final FriendModel friend = FriendModel.fromMap(data);
        onAddedData(friend);
      },
      onUpdated: (data) {
        final FriendModel friend = FriendModel.fromMap(data);
        onUpdated(friend);
      },
      onRemoved: (data) {
        final FriendModel friend = FriendModel.fromMap(data);
        onDeleted(friend);
      },
      onAllDataGet: onAllGet,
      onCompleted: (listener) {},
      queries: [
        QueryModel(
            field: "participants",
            value: [userId],
            type: QueryType.arrayContainsAny),
      ],
    );
  }

  /// Accept Friend Request
  Future<void> acceptFriendRequest({
    required String friendId,
  }) async {
    try {
      await FirestoreService().updateWithDocId(
        path: FIREBASE_COLLECTION_FRIENDS,
        docId: friendId,
        data: {
          'type': FriendType.friend.name.toLowerCase(),
          'requestAcceptTime': DateTime.now(),
        },
      );
    } catch (e) {
      log("[debug acceptFriendRequest] $e");
      throw throwAppException(e: e);
    }
  }

  /// Reject or remove Friend
  Future<void> deleteFriend({required String friendId}) async {
    try {
      await FirestoreService()
          .delete(collection: FIREBASE_COLLECTION_FRIENDS, docId: friendId);
    } catch (e) {
      log("[debug deleteFriend] $e");
      throw throwAppException(e: e);
    }
  }
}
