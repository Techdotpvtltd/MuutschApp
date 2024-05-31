// Project: 	   muutsch
// File:    	   chat_repo
// Path:    	   lib/repos/chat_repo.dart
// Author:       Ali Akbar
// Date:        31-05-24 11:59:48 -- Friday
// Description:

import 'dart:developer';

import '../exceptions/exception_parsing.dart';
import '../models/chat_model.dart';
import '../models/light_user_model.dart';
import '../models/user_model.dart';
import '../utils/constants/firebase_collections.dart';
import '../web_services/firestore_services.dart';
import '../web_services/query_model.dart';
import 'user_repo.dart';

class ChatRepo {
  // ===========================Singleton Instance ================================
  static final ChatRepo _instance = ChatRepo._internal();
  ChatRepo._internal();
  factory ChatRepo() => _instance;
  // ===========================Properties================================
  List<ChatModel> _chats = [];
  List<ChatModel> get chats => _chats;

  // ===========================Methods================================

  Future<void> fetchChats({ChatModel? lastChat}) async {
    try {
      final String userId = UserRepo().currentUser.uid;

      final List<QueryModel> queries = [
        QueryModel(
            field: "participantUids",
            value: userId,
            type: QueryType.arrayContains),
        QueryModel(field: "createdAt", value: false, type: QueryType.orderBy),
        QueryModel(
            field: "isChatEnabled", value: true, type: QueryType.isEqual),
        QueryModel(field: "", value: 5, type: QueryType.limit),
      ];

      /// Check If there is last chat doc exists
      if (lastChat != null) {
        queries.add(QueryModel(
            field: "",
            value: lastChat.toMap(),
            type: QueryType.startAfterDocument));
      }

      final List<Map<String, dynamic>> mappedData = await FirestoreService()
          .fetchWithMultipleConditions(
              collection: FIREBASE_COLLECTION_CHAT, queries: queries);
      final List<ChatModel> newChats =
          mappedData.map((e) => ChatModel.fromMap(e)).toList();
      _chats.addAll(newChats);
      _chats = _chats.toSet().toList(); // Remove Duplication Chats
    } catch (e) {
      log("[debug FetchChats] $e");
      throw throwAppException(e: e);
    }
  }

  /// Single Chat Method
  Future<ChatModel?> fetchChat({required String friendUid}) async {
    try {
      final String userId = UserRepo().currentUser.uid;
      final List<String> participants = [userId, friendUid];

      /// Check if chat exists and already fetched
      final int index = _chats
          .indexWhere((element) => element.participantUids.contains(friendUid));
      if (index > -1) {
        return _chats[index];
      }

      /// Otherwise fetch from server, if exists
      final List<Map<String, dynamic>> mappedData =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_CHAT,
        queries: [
          QueryModel(
              field: "participantUids",
              value: participants,
              type: QueryType.arrayContainsAny),
          QueryModel(field: "", value: 1, type: QueryType.limit),
        ],
      );

      if (mappedData.isNotEmpty) {
        return ChatModel.fromMap(mappedData.first);
      }
    } catch (e) {
      log("[debug FetchSingleChat] $e");
      throw throwAppException(e: e);
    }
    return null;
  }

  /// Create Chat Method
  Future<ChatModel> createChat({
    required bool isGroup,
    required bool isChatEnabled,
    String? chatTitle,
    String? chatAvatar,
    LightUserModel? friendProfile,
  }) async {
    try {
      final UserModel user = UserRepo().currentUser;
      final List<LightUserModel> participants = [];
      final List<String> participantIds = [];
      if (friendProfile != null) {
        participants.add(friendProfile);
        participantIds.add(friendProfile.uid);
      }

      // Current User Info
      participantIds.add(user.uid);
      participants.add(LightUserModel(
          uid: user.uid, name: user.name, avatarUrl: user.avatar));

      final ChatModel chatModel = ChatModel(
        uuid: "",
        createdAt: DateTime.now(),
        createdBy: user.uid,
        participants: participants,
        participantUids: participantIds,
        isChatEnabled: isChatEnabled,
        isGroup: isGroup,
        groupAvatar: chatAvatar,
        groupTitle: chatTitle,
      );

      final Map<String, dynamic> map =
          await FirestoreService().saveWithSpecificIdFiled(
        path: FIREBASE_COLLECTION_CHAT,
        data: chatModel.toMap(),
        docIdFiled: "uuid",
      );
      return ChatModel.fromMap(map);
    } catch (e) {
      log("[debug CreateChat] $e");
      throw throwAppException(e: e);
    }
  }
}