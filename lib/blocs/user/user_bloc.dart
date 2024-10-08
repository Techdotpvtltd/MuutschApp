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
    /// OnUpdateProfile Event
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

          if (event.bio != null) {
            user = user.copyWith(bio: event.bio);
          }

          emit(UserStateProfileUpdating());
          final UserModel updatedModel = await UserRepo().update(user: user);
          emit(UserStateProfileUpdated(user: updatedModel));
        } on AppException catch (e) {
          emit(UserStateProfileUpdatingFailure(exception: e));
        }
      },
    );

    /// OnFindUser
    on<UserEventFindBy>(
      (event, emit) async {
        try {
          emit(UserStateFinding());
          final List<UserModel> users = await UserRepo()
              .fetchUsersBy(searchText: event.searchText, bounds: event.bounds);
          emit(UserStateFinded(users: users));
        } on AppException catch (e) {
          emit(UserStateFindFailure(exception: e));
        }
      },
    );

    /// FetchSingleUser
    on<UserEventFetchDetail>(
      (event, emit) async {
        try {
          emit(UserStateFetchingSingle());
          final UserModel? user =
              await UserRepo().fetchUser(profileId: event.uid);
          if (user != null) {
            emit(UserStateFetchedSingle(user: user));
          } else {
            emit(UserStateFetchedSingleEmpty());
          }
        } on AppException catch (e) {
          emit(UserStateFetchSingleFailure(exception: e));
        }
      },
    );
  }
}
