import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:musch/utils/extensions/string_extension.dart';

import '../../exceptions/exception_parsing.dart';

import '../../web_services/firestore_services.dart';
import '../../exceptions/data_exceptions.dart';
import '../exceptions/auth_exceptions.dart';
import '../models/user_model.dart';
import '../utils/constants/firebase_collections.dart';
import '../web_services/query_model.dart';
import '../web_services/storage_services.dart';

class UserRepo {
  /// This class is used to get data/ request from user business layer and send
  /// to network layer.
  /// This class is used to parse user data from network layer and return back to
  /// business layer.
  ///

  static UserRepo _instance = UserRepo._internal();
  UserModel? _userModel;
  UserModel get currentUser =>
      _userModel == null ? throw AuthExceptionUserNotFound() : _userModel!;
  bool get isUserNull => _userModel == null;

  UserRepo._internal();

  /// Promise to return instance
  factory UserRepo() => _instance;

  /// Clear all
  void clearAll() {
    _userModel = null;
  }

  /// Fetch user
  Future<void> fetch() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser?.emailVerified == false) {
        throw AuthExceptionEmailVerificationRequired();
      }
      final data = await FirestoreService().fetchSingleRecord(
          path: FIREBASE_COLLECTION_USER, docId: currentUser?.uid ?? "");

      if (data == null) {
        throw AuthExceptionUserNotFound();
      }

      final UserModel userModel = UserModel.fromMap(data);
      _userModel = userModel;
      debugPrint("User = $_userModel");
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  /// Create User Profile
  Future<void> create({
    required String uid,
    required String name,
    required String email,
    String? avatarUrl,
    required String role,
  }) async {
    try {
      if (uid == "") {
        throw AuthExceptionUnAuthorized();
      }

      final UserModel user = UserModel(
        uid: uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
        role: role,
        avatar: avatarUrl ?? "",
      );

      final Map<String, dynamic> data = await FirestoreService().saveWithDocId(
        path: FIREBASE_COLLECTION_USER,
        docId: user.uid,
        data: user.toMap(),
      );
      _userModel = UserModel.fromMap(data);
    } catch (e) {
      debugPrint(e.toString());
      throw throwAppException(e: e);
    }
  }

  //  Update user Profile ====================================
  Future<UserModel> update({
    required UserModel user,
  }) async {
    try {
      // /// There is no user profile
      // if (_userModel == null) {
      //   final UserModel model = UserModel(
      //     uid:
      //     name: name,
      //     email: email,
      //     createdAt: DateTime.now(),
      //     avatar: imagePath ?? "",
      //   );
      //   await FirestoreService().saveWithDocId(
      //     path: FIREBASE_COLLECTION_USER,
      //     docId: model.uid,
      //     data: model.toMap(),
      //   );
      //   _userModel = model;
      //   return _userModel!;
      // }

      await FirestoreService().updateWithDocId(
          path: FIREBASE_COLLECTION_USER, docId: user.uid, data: user.toMap());
      _userModel = user;
      return _userModel!;
    } catch (e) {
      debugPrint(e.toString());
      throw throwAppException(e: e);
    }
  }

  /// Upload User Profile
  Future<String> uploadProfile({required String path}) async {
    try {
      final String collectionPath =
          "$FIREBASE_COLLECTION_USER_PROFILES/${UserRepo().currentUser.uid}";
      return await StorageService()
          .uploadImage(withFile: File(path), collectionPath: collectionPath);
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      throw e is FirebaseAuthException
          ? throwAuthException(errorCode: e.code)
          : throwDataException(errorCode: e.code);
    } catch (e) {
      debugPrint(e.toString());
      throw DataExceptionUnknown(message: e.toString());
    }
  }

  // Fetech Users with
  Future<List<UserModel>> fetchUsersBy(
      {String? searchText, LatLngBounds? bounds}) async {
    try {
      final List<QueryModel> queries = [];

      /// Search User by name, Email and phone number
      if (searchText != null) {
        // if (searchText.isNumeric()) {
        //   queries.add(QueryModel(
        //       field: "phone", value: searchText, type: QueryType.isEqual));
        // } else
        if (searchText.isValidEmail()) {
          queries.add(QueryModel(
              field: "email", value: searchText, type: QueryType.isEqual));
        } else {
          queries.add(QueryModel(
              field: "name",
              value: searchText,
              type: QueryType.isGreaterThanOrEqual));
          queries.add(
            QueryModel(
                field: "name",
                value: "$searchText\uf8ff",
                type: QueryType.isLessThanOrEqual),
          );
        }
      }

      /// Search User by location
      if (bounds != null) {
        final double minLat = bounds.southwest.latitude;
        final double maxLat = bounds.northeast.latitude;
        // final double minLng = bounds.southwest.longitude;
        // final double maxLng = bounds.northeast.longitude;

        queries.add(QueryModel(
            field: 'location.latitude',
            value: minLat,
            type: QueryType.isGreaterThanOrEqual));
        queries.add(QueryModel(
            field: 'location.latitude',
            value: maxLat,
            type: QueryType.isLessThanOrEqual));
      }

      debugPrint(queries.toString());
      final List<Map<String, dynamic>> listOfData =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_USER,
        queries: queries,
      );

      final users = listOfData.map((e) => UserModel.fromMap(e)).toList();
      users.removeWhere((element) =>
          element.role == "admin" || element.uid == currentUser.uid);
      return users;
    } catch (e) {
      log("[debug FindUserError] $e");
      throw throwAppException(e: e);
    }
  }

  // Fetch Profile
  Future<UserModel?> fetchUser({required String profileId}) async {
    try {
      if (profileId == currentUser.uid) {
        return currentUser;
      }

      if (profileId == "admin") {
        return null;
      }
      final List<Map<String, dynamic>> data =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_USER,
        queries: [
          QueryModel(field: "uid", value: profileId, type: QueryType.isEqual),
        ],
      );
      // ignore: sdk_version_since
      if (data.firstOrNull != null) {
        return UserModel.fromMap(data.first);
      }
      throw throwAuthException(errorCode: 'user-not-found');
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  // Fetch Profile
  Future<List<UserModel>> fetchUsers({required List<String> userIds}) async {
    try {
      final List<UserModel> users = [];
      for (final String id in userIds) {
        final List<Map<String, dynamic>> data =
            await FirestoreService().fetchWithMultipleConditions(
          collection: FIREBASE_COLLECTION_USER,
          queries: [
            QueryModel(field: "uid", value: id, type: QueryType.isEqual),
          ],
        );
        // ignore: sdk_version_since
        final UserModel user = UserModel.fromMap(data.first);
        if (user.uid != currentUser.uid) {
          users.add(user);
        }
      }
      return users;
    } catch (e) {
      throw throwAppException(e: e);
    }
  }
}
