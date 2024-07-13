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
  final List<FriendModel> _friends = [];
  List<FriendModel> get friends => _friends;
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
            topic: "$PUSH_NOTIFICATION_USER${friend.recieverId}",
            additionalData: {
              'friend': friend.toMap(isToJson: true),
            },
          );
          NotificationRepo().save(
              recieverId: event.recieverId,
              title: "Friend Request",
              avatar: UserRepo().currentUser.avatar,
              message:
                  "${UserRepo().currentUser.name} sends you a friend request.",
              data: friend.toMap(),
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
        final List<FriendModel> filteredFriends = List.from(friends
            .where((element) => element.type == FriendType.friend)
            .toList());
        emit(FriendStateFetchedFriends(friends: filteredFriends));
      },
    );

    /// OnFetch All Friends Event
    on<FriendEventFetch>(
      (event, emit) async {
        try {
          emit(FriendStateFetching());

          final f = await FriendRepo().fetchFriends();
          _friends.clear();
          _friends.addAll(f);
          add(FriendEventFetchPendingRequests());
        } on AppException catch (e) {
          emit(FriendStateFetchFailure(exception: e));
        }

        // await FriendRepo().fetchFriends(
        //   onAddedData: (friend) {
        //     final int index =
        //         friends.indexWhere((element) => element.uuid == friend.uuid);
        //     if (index > -1) {
        //       friends[index] = friend;
        //     } else {
        //       friends.insert(0, friend);
        //     }
        //     emit(FriendStateDataAdded());
        //     add(FriendEventFetchPendingRequests());
        //   },
        //   onUpdated: (friend) {
        //     final int index =
        //         friends.indexWhere((element) => element.uuid == friend.uuid);
        //     if (index > -1) {
        //       friends[index] = friend;
        //       emit(FriendStateDataUpdated(friend: friend));
        //       add(FriendEventFetchPendingRequests());
        //     }
        //   },
        //   onDeleted: (friend) {
        //     final int index =
        //         friends.indexWhere((element) => element.uuid == friend.uuid);
        //     if (index > -1) {
        //       friends.removeAt(index);
        //       emit(FriendStateDataRemoved(friend: friend));
        //       add(FriendEventFetchPendingRequests());
        //     }
        //   },
        //   onError: (e) {
        //     emit(FriendStateFetchedAll());
        //   },
        //   onAllGet: () {},
        // );
      },
    );

    /// Accept Friend Request
    on<FriendEventAccept>(
      (event, emit) async {
        try {
          emit(FriendStateAccepting());

          await FriendRepo().acceptFriendRequest(friendId: event.friendId);
          final int index =
              _friends.indexWhere((element) => element.uuid == event.friendId);
          if (index > -1) {
            _friends[index] = _friends[index].copyWith(type: FriendType.friend);
            emit(FriendStateAccepted(frined: friends[index]));
            FireNotification().sendNotification(
                title: "Friend Request Accepted",
                type: 'request',
                description:
                    "${UserRepo().currentUser.name} accepted your friend request.",
                topic: "$PUSH_NOTIFICATION_USER${friends[index].senderId}",
                additionalData: {
                  'friend': friends[index].toMap(isToJson: true),
                });
            NotificationRepo().save(
              recieverId: friends[index].senderId,
              title: "Friend Request Accepted",
              avatar: UserRepo().currentUser.avatar,
              message:
                  "${UserRepo().currentUser.name} accepted your friend request. Now you can start chat.",
              type: NotificationType.user,
              data: friends[index].toMap(),
            );
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
          _friends.removeWhere((element) => element.uuid == event.friendId);
          emit(FriendStateRemoved(friendId: event.friendId));
        } on AppException catch (e) {
          emit(FriendStateRemoveFailure(exception: e));
        }
      },
    );
  }
}
