import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musch/models/message_model.dart';
import 'package:musch/repos/user_repo.dart';

import '../../exceptions/app_exceptions.dart';
import '../../exceptions/exception_parsing.dart';
import '../../repos/message_repo.dart';
import '../../services/notification_services/fire_notification.dart';
import '../../utils/constants/constants.dart';
import 'message_event.dart';
import 'message_state.dart';

/// Project: 	   wasteapp
/// File:    	   mesaage_bloc
/// Path:    	   lib/blocs/message/mesaage_bloc.dart
/// Author:       Ali Akbar
/// Date:        21-03-24 14:59:11 -- Thursday
/// Description:

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageStateInitial()) {
    // Fetch Messages Event
    on<MessageEventFetch>((event, emit) async {
      try {
        emit(MessageStateFetching());
        await MessageRepo().fetchMessages(
          conversationId: event.conversationId,
          onData: () {
            emit(MessageStateFetched());
          },
          onError: (e) {
            emit(MessageStateFetchFailure(exception: e));
          },
        );
      } catch (e) {
        throw throwAppException(e: e);
      }
    });

    // Send Message Event
    on<MessageEventSend>(
      (event, emit) async {
        try {
          emit(MessageStateSending());
          await MessageRepo().sendMessage(
            conversationId: event.chat.uuid,
            type: event.type,
            content: event.content,
            onMessagePrepareToSend: () {
              emit(MessageStatePrepareToSend());
            },
          );
          emit(MessageStateSent());
          for (final String uuid in event.chat.participantUids) {
            if (uuid == UserRepo().currentUser.uid) {
              continue;
            }

            FireNotification().sendNotification(
              title: UserRepo().currentUser.name,
              type: "message",
              description: event.type == MessageType.text
                  ? event.content
                  : "Sent a media.",
              topic: "$PUSH_NOTIFICATION_USER${uuid}",
              additionalData: {
                'type': 'chat',
                'chat': event.chat.toMap(isToJson: true),
              },
            );
          }
        } on AppException catch (e) {
          emit(MessageStateSendFailure(exception: e));
        }
      },
    );

    // ON New Message
    on<MessageEventNew>(
        (event, emit) => emit(MessageStateNew(isNew: event.isNew)));
  }
}
