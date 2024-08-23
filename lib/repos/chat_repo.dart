// Project: 	   muutsch
// File:    	   chat_repo
// Path:    	   lib/repos/chat_repo.dart
// Author:       Ali Akbar
// Date:        31-05-24 11:59:48 -- Friday
// Description:

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:musch/exceptions/app_exceptions.dart';
import 'package:musch/exceptions/data_exceptions.dart';

import '../exceptions/exception_parsing.dart';
import '../models/chat_model.dart';
import '../models/other_user_model.dart';
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

  void clearAll() {
    _chats = [];
  }

  Future<void> fetchChats({
    ChatModel? lastChat,
    required VoidCallback onSuccess,
    required Function(AppException) onError,
  }) async {
    final String userId = UserRepo().currentUser.uid;
    _chats.clear();
    final List<QueryModel> queries = [
      QueryModel(
        field: "participantUids",
        value: userId,
        type: QueryType.arrayContains,
      ),
      QueryModel(field: "createdAt", value: false, type: QueryType.orderBy),
      QueryModel(field: "isChatEnabled", value: true, type: QueryType.isEqual),
      QueryModel(field: "", value: 15, type: QueryType.limit),
    ];

    /// Check If there is last chat doc exists
    if (lastChat != null) {
      queries.add(QueryModel(
          field: "",
          value: lastChat.toMap(),
          type: QueryType.startAfterDocument));
    }

    await FirestoreService().fetchWithListener(
        collection: FIREBASE_COLLECTION_CHAT,
        onError: (e) {
          log("[debug FetchChats] $e");
          onError(throwAppException(e: e));
        },
        onAdded: (data) {
          final chat = ChatModel.fromMap(data);
          final int index =
              _chats.indexWhere((element) => element.uuid == chat.uuid);
          if (index == -1) {
            _chats.add(chat);
            onSuccess();
          }
        },
        onRemoved: (data) {
          final chat = ChatModel.fromMap(data);
          final int index =
              _chats.indexWhere((element) => element.uuid == chat.uuid);
          if (index > -1) {
            _chats.removeAt(index);
            onSuccess();
          }
        },
        onUpdated: (data) {
          final chat = ChatModel.fromMap(data);
          final int index =
              _chats.indexWhere((element) => element.uuid == chat.uuid);

          if (index > -1) {
            if (!chat.isChatEnabled ||
                !chat.participantUids.contains(UserRepo().currentUser.uid)) {
              _chats.removeAt(index);
            }
            _chats[index] = chat;
          } else {
            if (chat.isChatEnabled) {
              _chats.add(chat);
            }
          }
          onSuccess();
        },
        onAllDataGet: () {
          onSuccess();
        },
        onCompleted: (l) {},
        queries: queries);
  }

  Future<ChatModel?> fetchGroupChat({required String eventId}) async {
    try {
      final int index = _chats.indexWhere((element) => element.uuid == eventId);
      if (index > -1) {
        return _chats[index];
      }

      final Map<String, dynamic>? data = await FirestoreService()
          .fetchSingleRecord(path: FIREBASE_COLLECTION_CHAT, docId: eventId);
      if (data != null) {
        final ChatModel chat = ChatModel.fromMap(data);
        if (chat.participantUids.contains(UserRepo().currentUser.uid)) {
          _chats.add(chat);
        }
        return chat;
      }
      return null;
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  Future<void> joinGroupChat({required String eventId}) async {
    try {
      final UserModel user = UserRepo().currentUser;
      await FirestoreService().updateWithDocId(
        path: FIREBASE_COLLECTION_CHAT,
        docId: eventId,
        data: {
          "participantUids": FieldValue.arrayUnion([user.uid]),
          "participants": FieldValue.arrayUnion(
            [
              OtherUserModel(
                uid: user.uid,
                name: user.name,
                avatarUrl: user.avatar,
                about: user.bio,
                createdAt: DateTime.now(),
              ).toMap(),
            ],
          ),
        },
      );
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  Future<void> removeMember(
      {required String chatId, required OtherUserModel member}) async {
    try {
      await FirestoreService().updateWithDocId(
        path: FIREBASE_COLLECTION_CHAT,
        docId: chatId,
        data: {
          "participantUids": FieldValue.arrayRemove([member.uid]),
          "participants": FieldValue.arrayRemove(
            [member.toMap()],
          ),
        },
      );
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  /// Chat Visibilty Status
  Future<void> setGroupChatVisibility(
      {required bool status, required String chatId}) async {
    try {
      await FirestoreService().updateWithDocId(
        path: FIREBASE_COLLECTION_CHAT,
        docId: chatId,
        data: {
          "isChatEnabled": status,
        },
      );
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  /// Single Chat Method
  Future<ChatModel?> fetchChat(
      {required String id, bool isGroupChat = false}) async {
    try {
      final String userId = UserRepo().currentUser.uid;
      final List<String> participants = [userId, id];
      participants.sort();

      /// Check if chat exists and already fetched
      final int index = _chats.indexWhere((element) => isGroupChat
          ? element.uuid == id
          : element.participantUids.contains(id));
      if (index > -1) {
        return _chats[index];
      }

      /// Otherwise fetch from server, if exists
      final List<Map<String, dynamic>> mappedData =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_CHAT,
        queries: [
          if (!isGroupChat)
            QueryModel(
              field: "compositeKey",
              value: participants.join("_").toString(),
              type: QueryType.isEqual,
            ),
          if (isGroupChat)
            QueryModel(
              field: "uuid",
              value: id,
              type: QueryType.isEqual,
            ),
          if (isGroupChat)
            QueryModel(
              field: "isChatEnabled",
              value: true,
              type: QueryType.isEqual,
            ),
          QueryModel(field: "", value: 1, type: QueryType.limit),
        ],
      );

      if (mappedData.isNotEmpty) {
        // PushNotificationServices().subscribe(
        //     forTopic:
        //         "$PUSH_NOTIFICATION_EVENT_CHATS${mappedData.first["uuid"]}");
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
    String? eventId,
    OtherUserModel? friendProfile,
  }) async {
    try {
      final UserModel user = UserRepo().currentUser;
      final List<OtherUserModel> participants = [];
      final List<String> participantIds = [];
      if (isGroup && eventId == null) {
        throw DataExceptionUnknown(message: "Please Provide eventId");
      }

      if (friendProfile != null) {
        participants.add(friendProfile);
        participantIds.add(friendProfile.uid);
      }

      // Current User Info
      participantIds.add(user.uid);
      participants.add(
        OtherUserModel(
          uid: user.uid,
          name: user.name,
          avatarUrl: user.avatar,
          about: user.bio ?? "",
          createdAt: DateTime.now(),
        ),
      );

      participantIds.sort();
      final ChatModel chatModel = ChatModel(
        uuid: eventId ?? "",
        createdAt: DateTime.now(),
        createdBy: user.uid,
        participants: participants,
        participantUids: participantIds,
        isChatEnabled: isChatEnabled,
        isGroup: isGroup,
        groupAvatar: chatAvatar,
        groupTitle: chatTitle,
        compositeKey: participantIds.join("_"),
      );

      final Map<String, dynamic> map = isGroup
          ? await FirestoreService().saveWithDocId(
              data: chatModel.toMap(),
              path: FIREBASE_COLLECTION_CHAT,
              docId: eventId ?? "",
            )
          : await FirestoreService().saveWithSpecificIdFiled(
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
