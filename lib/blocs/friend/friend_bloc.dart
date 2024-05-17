// Project: 	   muutsch
// File:    	   friend_bloc
// Path:    	   lib/blocs/friend/friend_bloc.dart
// Author:       Ali Akbar
// Date:        17-05-24 14:22:07 -- Friday
// Description:

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/app_exceptions.dart';
import '../../models/friend_model.dart';
import '../../repos/friend_repo.dart';
import '../../repos/user_repo.dart';
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
        } on AppException catch (e) {
          emit(FriendStateSendFailure(exception: e));
        }
      },
    );

    on<FriendEventFetchPendingRequests>(
      (event, emit) {
        final List<FriendModel> filteredFriends =
            List<FriendModel>.from(friends)
                .where((element) =>
                    element.recieverId == userId &&
                    element.type == FriendType.request)
                .toList();
        emit(FriendStateFetchedPendingRequests(friends: filteredFriends));
      },
    );

    /// OnFetch All Friends Event
    on<FriendEventFetch>(
      (event, emit) async {
        emit(FriendStateFetching());

        await FriendRepo().fetchFriends(
          onUpdateData: (friend) {
            final int index =
                friends.indexWhere((element) => element.uuid == friend);
            if (index > -1) {
              friends[index] = friend; // Updating
            } else {
              friends.insert(0, friend);
            }
            emit(FriendStateFetched());

            if (friend.type == FriendType.request &&
                friend.recieverId == userId) {
              add(FriendEventFetchPendingRequests());
            }

            debugPrint(friends.toString());
          },
          onError: (e) {
            emit(FriendStateFetchedAll());
          },
          onAllGet: () {},
        );
      },
    );
  }
}
