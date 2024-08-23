// Project: 	   muutsch
// File:    	   notification_repo
// Path:    	   lib/repos/notification_repo.dart
// Author:       Ali Akbar
// Date:        29-05-24 16:45:35 -- Wednesday
// Description:

import 'dart:developer';

import '../exceptions/exception_parsing.dart';
import '../models/notification_model.dart';
import '../models/user_model.dart';
import '../utils/constants/firebase_collections.dart';
import '../web_services/firestore_services.dart';
import '../web_services/query_model.dart';
import 'user_repo.dart';

class NotificationRepo {
  // ===========================Singleton Instance================================
  static final NotificationRepo _instance = NotificationRepo._internal();
  NotificationRepo._internal();
  factory NotificationRepo() => _instance;
  // ===========================Properties================================

  // ===========================Methods================================
  Future<List<NotificationModel>> fetech() async {
    try {
      final String userId = UserRepo().currentUser.uid;

      final List<Map<String, dynamic>> listOfData =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_NOTIFICATION,
        queries: [
          QueryModel(
              field: "receiverId", value: userId, type: QueryType.isEqual),
          QueryModel(field: "", value: 20, type: QueryType.limit),
          QueryModel(field: "createdAt", value: true, type: QueryType.orderBy),
        ],
      );

      return listOfData.map((e) => NotificationModel.fromMap(e)).toList();
    } catch (e) {
      log("[debug fetchNotification] $e");
      throw throwAppException(e: e);
    }
  }

  Future<void> save(
      {required String recieverId,
      required String title,
      String? contentId,
      required String message,
      Map<String, dynamic>? data,
      required String avatar,
      required NotificationType type}) async {
    try {
      final UserModel user = UserRepo().currentUser;
      final NotificationModel model = NotificationModel(
        uuid: "",
        title: title,
        message: message,
        senderId: user.uid,
        receiverId: recieverId,
        type: type,
        createdAt: DateTime.now(),
        avatar: avatar,
        contentId: contentId ?? user.uid,
        data: data,
      );
      FirestoreService().saveWithSpecificIdFiled(
          path: FIREBASE_COLLECTION_NOTIFICATION,
          data: model.toMap(),
          docIdFiled: 'uuid');
    } catch (e) {
      log("[debug saveNotification] $e");
      throw throwAppException(e: e);
    }
  }

  /// Delete Notification
  void delete({required String notificationId}) async {
    FirestoreService().delete(
        collection: FIREBASE_COLLECTION_NOTIFICATION, docId: notificationId);
  }
}
