// Project: 	   muutsch
// File:    	    chat_bloc
// Path:    	   lib/blocs/chat/ chat_bloc.dart
// Author:       Ali Akbar
// Date:        31-05-24 13:44:34 -- Friday
// Description:

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musch/repos/user_repo.dart';
import 'package:musch/services/notification_services/fire_notification.dart';
import 'package:musch/utils/constants/constants.dart';

import '../../exceptions/app_exceptions.dart';
import '../../models/chat_model.dart';
import '../../models/notification_model.dart';
import '../../repos/chat_repo.dart';
import '../../repos/notification_repo.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatStateInitial()) {
    /// Fetch Single Chat Evenst
    on<ChatEventFetch>(
      (event, emit) async {
        try {
          emit(ChatStateFetching());
          final ChatModel? chat =
              await ChatRepo().fetchChat(friendUid: event.friendProfile.uid);

          if (chat != null) {
            emit(ChatStateFetched(chat: chat));
            return;
          }

          /// Otherwise called create event to create the chat
          add(ChatEventCreate(friendProfile: event.friendProfile, ids: []));
        } on AppException catch (e) {
          emit(ChatStateFetchFailure(exception: e));
        }
      },
    );

    on<ChatEventFetchAll>(
      (event, emit) async {
        emit(ChatStateFetchingAll());
        await ChatRepo().fetchChats(
          onSuccess: () {
            emit(ChatStateFetchedAll());
          },
          onError: (e) {
            emit(ChatStateFetchAllFailure(exception: e));
          },
        );
      },
    );

    /// Create Chat Event
    on<ChatEventCreate>(
      (event, emit) async {
        try {
          emit(ChatStateCreating());
          final ChatModel chat = await ChatRepo().createChat(
              isGroup: event.isGroup,
              isChatEnabled: event.isChatEnabled,
              chatTitle: event.chatTitle,
              chatAvatar: event.chatAvatar,
              eventId: event.eventId,
              friendProfile: event.friendProfile);
          emit(ChatStateCreated(chat: chat));

          if (event.isGroup) {
            for (final String id in event.ids) {
              FireNotification().sendNotification(
                title: event.chatTitle ?? "",
                description:
                    "Group Chat is available for the event ${event.chatTitle ?? ""}. You can now connect with the member of this event.",
                topic: "$PUSH_NOTIFICATION_FRIEND_REQUEST$id",
                type: "event",
              );

              NotificationRepo().save(
                  recieverId: id,
                  title: "Event Update",
                  message:
                      "Group Chat is available for the event ${event.chatTitle}. You can now connect with the member of this event.",
                  type: NotificationType.event);
            }
          }
        } on AppException catch (e) {
          emit(ChatStateCreateFailure(exception: e));
        }
      },
    );

    /// Set Chat Visibility
    on<ChatEventUpdateVisibilityStatus>(
      (event, emit) async {
        try {
          emit(ChatStateUpdatingGroupStatus());
          await ChatRepo().setGroupChatVisibility(
              status: event.status, chatId: event.chatId);
          emit(ChatStateUpdatedStatus(
              eventId: event.chatId, status: event.status));

          for (final String id in event.ids) {
            if (id != UserRepo().currentUser.uid) {
              FireNotification().sendNotification(
                title: event.groupTitle,
                description: event.status
                    ? "Group Chat is available for the event ${event.groupTitle}. You can now connect with the member of this event."
                    : "Group Chat is available for the event ${event.groupTitle}.",
                topic: "$PUSH_NOTIFICATION_FRIEND_REQUEST$id",
                type: "event",
              );

              NotificationRepo().save(
                  recieverId: id,
                  title: "Event Update",
                  message: event.status
                      ? "Group Chat is available for the event ${event.groupTitle}. You can now connect with the member of this event."
                      : "Group Chat is available for the event ${event.groupTitle}.",
                  type: NotificationType.event);
            }
          }
        } on AppException catch (e) {
          emit(ChatStateUpdateGroupStatusFailure(exception: e));
        }
      },
    );

    /// Fetch Group Chat
    on<ChatEventFetchGroupChat>(
      (event, emit) async {
        try {
          emit(ChatStateFetching());
          final ChatModel? chat =
              await ChatRepo().fetchGroupChat(eventId: event.eventId);

          emit(ChatStateFetched(chat: chat));
        } on AppException catch (e) {
          emit(ChatStateFetchFailure(exception: e));
        }
      },
    );

    /// Join Group Chat
    on<ChatEventJoinGroupChat>(
      (event, emit) async {
        try {
          emit(ChatStateJoining());
          await ChatRepo().joinGroupChat(eventId: event.eventId);
          emit(ChatStateJoined());
        } on AppException catch (e) {
          emit(ChatStateJoinFailure(exception: e));
        }
      },
    );
  }
}
