// Project: 	   muutsch
// File:    	   friend_bloc
// Path:    	   lib/blocs/friend/friend_bloc.dart
// Author:       Ali Akbar
// Date:        17-05-24 14:22:07 -- Friday
// Description:

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/app_exceptions.dart';
import '../../models/friend_model.dart';
import '../../models/notification_model.dart';
import '../../repos/friend_repo.dart';
import '../../repos/notification_repo.dart';
import '../../repos/user_repo.dart';
import '../../services/notification_services/fire_notification.dart';
import '../../utils/constants/constants.dart';
import 'friend_event.dart';
import 'friend_state.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  final List<FriendModel> friends = [];
  final String userId = UserRepo().currentUser.uid;

  FriendBloc() : super(FriendStateInitial()) {
    /// OnSendRequest Event
    on<FriendEventSend>(
      (event, emit) async {
        try {
          emit(FriendStateSending());
          final FriendModel friend =
              await FriendRepo().sendRequest(recieverId: event.recieverId);
          emit(FriendStateSent(friend: friend));
          FireNotification().sendNotification(
              title: "Friend Request",
              type: 'request',
              description:
                  "${UserRepo().currentUser.name} sends you a friend request.",
              topic: "$PUSH_NOTIFICATION_FRIEND_REQUEST${friend.recieverId}");
          NotificationRepo().save(
              recieverId: event.recieverId,
              title: "Friend Request",
              message: " sends you a friend request.",
              type: NotificationType.user);
        } on AppException catch (e) {
          emit(FriendStateSendFailure(exception: e));
        }
      },
    );

    /// OnGetFriend Event
    on<FriendEventGet>(
      (event, emit) {
        try {
          final FriendModel friend = friends.firstWhere(
              (element) => element.participants.contains(event.friendId));
          emit(FriendStateGot(friend: friend));
        } catch (e) {
          log("[debug FriendEventGet] $e");
        }
      },
    );

    /// OnPendingRequest Fetch
    on<FriendEventFetchPendingRequests>(
      (event, emit) {
        final List<FriendModel> filteredFriends = friends
            .where((element) =>
                element.recieverId == userId &&
                element.type == FriendType.request)
            .toList();
        emit(FriendStateFetchedPendingRequests(friends: filteredFriends));
      },
    );

    /// OnAccepted Frined Event Fetch
    on<FriendEventFetchFriends>(
      (event, emit) {
        final List<FriendModel> filteredFriends = friends
            .where((element) => element.type == FriendType.friend)
            .toList();
        emit(FriendStateFetchedFriends(friends: filteredFriends));
      },
    );

    /// OnFetch All Friends Event
    on<FriendEventFetch>(
      (event, emit) async {
        emit(FriendStateFetching());

        await FriendRepo().fetchFriends(
          onAddedData: (friend) {
            friends.insert(0, friend);
            emit(FriendStateDataAdded());
            add(FriendEventFetchPendingRequests());
          },
          onUpdated: (friend) {
            final int index =
                friends.indexWhere((element) => element.uuid == friend.uuid);
            if (index > -1) {
              friends[index] = friend;
              emit(FriendStateDataUpdated(friend: friend));
              add(FriendEventFetchPendingRequests());
            }
          },
          onDeleted: (friend) {
            final int index =
                friends.indexWhere((element) => element.uuid == friend.uuid);
            if (index > -1) {
              friends.removeAt(index);
              emit(FriendStateDataRemoved(friend: friend));
              add(FriendEventFetchPendingRequests());
            }
          },
          onError: (e) {
            emit(FriendStateFetchedAll());
          },
          onAllGet: () {},
        );
      },
    );

    /// Accept Friend Request
    on<FriendEventAccept>(
      (event, emit) async {
        try {
          emit(FriendStateAccepting());
          await FriendRepo().acceptFriendRequest(friendId: event.friendId);
          final int index =
              friends.indexWhere((element) => element.uuid == event.friendId);
          if (index > -1) {
            friends[index] = friends[index].copyWith(type: FriendType.friend);
            emit(FriendStateAccepted(frined: friends[index]));
            FireNotification().sendNotification(
                title: "Friend Request Accepted",
                type: 'request',
                description:
                    "${UserRepo().currentUser.name} accepted your friend request.",
                topic:
                    "$PUSH_NOTIFICATION_FRIEND_REQUEST${friends[index].senderId}");
            NotificationRepo().save(
                recieverId: friends[index].senderId,
                title: "Friend Request Accepted",
                message:
                    " accepted your friend request. Now you can start chat.",
                type: NotificationType.user);
          }
        } on AppException catch (e) {
          emit(FriendStateAcceptFailure(exception: e));
        }
      },
    );

    /// On Friend Request Deleted or rejected
    on<FriendEventRemove>(
      (event, emit) async {
        try {
          emit(FriendStateRemoving());
          await FriendRepo().deleteFriend(friendId: event.friendId);
          emit(FriendStateRemoved());
        } on AppException catch (e) {
          emit(FriendStateRemoveFailure(exception: e));
        }
      },
    );
  }
}
