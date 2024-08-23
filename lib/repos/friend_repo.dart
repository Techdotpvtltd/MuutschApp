// Project: 	   muutsch
// File:    	   friend_repo
// Path:    	   lib/repos/friend_repo.dart
// Author:       Ali Akbar
// Date:        17-05-24 14:01:27 -- Friday
// Description:

import 'dart:developer';
import 'package:musch/exceptions/data_exceptions.dart';
import 'package:musch/manager/app_manager.dart';
import 'package:musch/utils/extensions/date_extension.dart';

import '../exceptions/exception_parsing.dart';
import '../models/friend_model.dart';
import '../utils/constants/firebase_collections.dart';
import '../web_services/firestore_services.dart';
import '../web_services/query_model.dart';
import 'user_repo.dart';

class FriendRepo {
  final String userId = UserRepo().currentUser.uid;
  final bool isSusbcribed = AppManager().isActiveSubscription;
  // ===========================API Methods================================
  Future<FriendModel> sendRequest({required String recieverId}) async {
    try {
      if (!isSusbcribed) {
        if (!(await canSendRequest())) {
          throw DataExceptionSubscriptionRequired(
              message:
                  "You’ve reached your friend request limit for this month. Please subscribe to send more requests.");
        }
      }
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

  Future<bool> canSendRequest() async {
    final List<Map<String, dynamic>> data =
        await FirestoreService().fetchWithMultipleConditions(
      collection: FIREBASE_COLLECTION_FRIENDS,
      queries: [
        QueryModel(field: "senderId", value: userId, type: QueryType.isEqual),
        QueryModel(
            field: "requestSendTime", value: true, type: QueryType.orderBy),
        QueryModel(
            field: "requestSendTime",
            value: monthStartDay(),
            type: QueryType.isGreaterThanOrEqual),
        QueryModel(field: '', value: 3, type: QueryType.limit),
      ],
    );

    return data.length < 3;
  }

  /// Fetch All Friends Request
  Future<List<FriendModel>> fetchFriends() async {
    try {
      final String userId = UserRepo().currentUser.uid;

      final List<Map<String, dynamic>> data =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_FRIENDS,
        queries: [
          QueryModel(
              field: "participants",
              value: [userId],
              type: QueryType.arrayContainsAny),
          QueryModel(
              field: 'type', value: 'removed', type: QueryType.isNotEqual),
        ],
      );

      return data.map((e) => FriendModel.fromMap(e)).toList();
    } catch (e) {
      log("[debug FriendRepo] $e", name: "fetchFriends");
      throw throwAppException(e: e);
    }
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
      await FirestoreService().updateWithDocId(
        path: FIREBASE_COLLECTION_FRIENDS,
        docId: friendId,
        data: {'type': 'removed'},
      );
    } catch (e) {
      log("[debug deleteFriend] $e");
      throw throwAppException(e: e);
    }
  }
}
