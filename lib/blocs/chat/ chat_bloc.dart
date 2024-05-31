// Project: 	   muutsch
// File:    	    chat_bloc
// Path:    	   lib/blocs/chat/ chat_bloc.dart
// Author:       Ali Akbar
// Date:        31-05-24 13:44:34 -- Friday
// Description:

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/app_exceptions.dart';
import '../../models/chat_model.dart';
import '../../repos/chat_repo.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatStateInitial()) {
    /// Fetch Single Chat Event
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
          add(ChatEventCreate(friendProfile: event.friendProfile));
        } on AppException catch (e) {
          emit(ChatStateFetchFailure(exception: e));
        }
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
              friendProfile: event.friendProfile);
          emit(ChatStateCreated(chat: chat));
        } on AppException catch (e) {
          emit(ChatStateCreateFailure(exception: e));
        }
      },
    );
  }
}
