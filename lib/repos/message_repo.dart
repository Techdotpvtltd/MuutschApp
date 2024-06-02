// ignore: dangling_library_doc_comments
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:musch/utils/extensions/date_extension.dart';

import '../exceptions/app_exceptions.dart';
import '../exceptions/data_exceptions.dart';
import '../exceptions/exception_parsing.dart';
import '../models/message_model.dart';
import '../utils/constants/firebase_collections.dart';
import '../web_services/storage_services.dart';
import 'user_repo.dart';

/// Project: 	   wasteapp
/// File:    	   message_repo
/// Path:    	   lib/repos/message_repo.dart
/// Author:       Ali Akbar
/// Date:        21-03-24 15:00:37 -- Thursday
/// Description:

class MessageRepo {
  // ===========================Singleton================================
  static final MessageRepo _instance = MessageRepo._internal();
  MessageRepo._internal();
  factory MessageRepo() => _instance;
  // ====================================================================

  final List<MessageModel> _messages = [];
  List<GroupedMessageModel> get messages {
    final List<GroupedMessageModel> groupedMessages = [];
    for (final message in _messages) {
      final DateTime date = message.messageTime.onlyDate();
      final int index =
          groupedMessages.indexWhere((element) => element.date == date);
      if (index > -1) {
        groupedMessages[index].messages.add(message);
      } else {
        groupedMessages
            .add(GroupedMessageModel(date: date, messages: [message]));
      }
    }
    groupedMessages.sort((a, b) =>
        b.date.millisecondsSinceEpoch.compareTo(a.date.millisecondsSinceEpoch));
    return groupedMessages;
  }

  // Fetch Messages
  Future<void> fetchMessages(
      {required VoidCallback onData,
      required String conversationId,
      required Function(AppException) onError}) async {
    final FirebaseFirestore instance = FirebaseFirestore.instance;
    final ref = instance
        .collection(FIREBASE_COLLECTION_MESSAGES)
        .where('conversationId', isEqualTo: conversationId);

    // Create a Completer to signal completion
    Completer<void> completer = Completer<void>();

    ref.snapshots().listen(
          (querySnapshot) {
            for (final change in querySnapshot.docChanges) {
              final Map<String, dynamic>? data = change.doc.data();
              if (data != null) {
                final MessageModel messageModel = MessageModel.fromMap(data);
                final int index = _messages.indexWhere(
                    (element) => element.messageId == messageModel.messageId);
                if (index > -1) {
                  _messages[index] = messageModel;
                } else {
                  _messages.add(messageModel);
                }
                // Sort messages
                _messages.sort((a, b) => a.messageTime.millisecondsSinceEpoch
                    .compareTo(b.messageTime.millisecondsSinceEpoch));
                onData();
              }
            }
          },
          onError: (e) => onError(throwAppException(e: e)),
          onDone: () {
            // Signal completion on error as well
            completer.complete();
          },
        );

    // Wait for the operation to complete before returning
    await completer.future;
  }

  // Send Message
  Future<void> sendMessage(
      {required MessageType type,
      required String content,
      required VoidCallback onMessagePrepareToSend,
      required String conversationId}) async {
    try {
      if (content == "") {
        throw throwDataException(
            errorCode: "content-null", message: "Oops!, cant send the message");
      }
      final String userId = UserRepo().currentUser.uid;
      final FirebaseFirestore instance = FirebaseFirestore.instance;
      final ref = instance.collection(FIREBASE_COLLECTION_MESSAGES).doc();

      String messageContent = content;

      /// Add without conversationId means to check
      /// if the message sent to firestore or not.
      final MessageModel messageModel = MessageModel(
          messageId: ref.id,
          conversationId: "",
          content: content,
          messageTime: DateTime.now(),
          type: type,
          senderId: userId);
      _messages.add(messageModel);
      onMessagePrepareToSend();

      if (type == MessageType.photo) {
        final String collectionPath =
            "$FIREBASE_COLLECTION_MESSAGES/$conversationId/${ref.id}";
        messageContent = await StorageService().uploadImage(
            withFile: File(content), collectionPath: collectionPath);
      }

      final MessageModel updatedModel = messageModel.copyWith(
          conversationId: conversationId, content: messageContent);

      await ref.set(updatedModel.toMap());
    } catch (e) {
      throw throwAppException(e: e);
    }
  }
}
