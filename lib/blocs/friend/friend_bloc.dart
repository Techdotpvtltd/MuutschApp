// Project: 	   muutsch
// File:    	   friend_bloc
// Path:    	   lib/blocs/friend/friend_bloc.dart
// Author:       Ali Akbar
// Date:        17-05-24 14:22:07 -- Friday
// Description:

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/app_exceptions.dart';
import '../../models/friend_model.dart';
import '../../repos/friend_repo.dart';
import 'friend_event.dart';
import 'friend_state.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
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
  }
}
