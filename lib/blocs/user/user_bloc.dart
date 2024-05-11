import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/app_exceptions.dart';
import '../../models/user_model.dart';
import '../../repos/user_repo.dart';
import 'user_event.dart';
import 'user_state.dart';

/// Project: 	   playtogethher
/// File:    	   user_bloc
/// Path:    	   lib/blocs/user/user_bloc.dart
/// Author:       Ali Akbar
/// Date:        13-03-24 15:43:26 -- Wednesday
/// Description:

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserStateInitial()) {
    on<UserEventUpdateProfile>(
      (event, emit) async {
        try {
          UserModel user = UserRepo().currentUser;
          String avatarUrl = user.avatar;

          if (event.avatar != null) {
            emit(UserStateAvatarUploading());
            avatarUrl =
                await UserRepo().uploadProfile(path: event.avatar ?? "");
            emit(UserStateAvatarUploaded());
            user = user.copyWith(avatar: avatarUrl);
          }

          if (event.children != null) {
            user = user.copyWith(children: event.children);
          }

          if (event.numberOfChildren != null) {
            user = user.copyWith(numOfChildren: event.numberOfChildren);
          }

          if (event.location != null) {
            user = user.copyWith(location: event.location);
          }

          if (event.interests != null) {
            user = user.copyWith(interests: event.interests);
          }

          if (event.name != null) {
            user = user.copyWith(name: event.name);
          }

          if (event.email != null) {
            user = user.copyWith(email: event.email);
          }

          emit(UserStateProfileUpdating());
          final UserModel updatedModel = await UserRepo().update(user: user);
          emit(UserStateProfileUpdated(user: updatedModel));
        } on AppException catch (e) {
          emit(UserStateProfileUpdatingFailure(exception: e));
        }
      },
    );
  }
}
