// Project: 	   muutsch
// File:    	   event_repo
// Path:    	   lib/repos/event_repo.dart
// Author:       Ali Akbar
// Date:        14-05-24 16:20:52 -- Tuesday
// Description:

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:musch/models/other_user_model.dart';

import '../exceptions/exception_parsing.dart';
import '../models/event_model.dart';
import '../models/location_model.dart';
import '../models/user_model.dart';
import '../utils/constants/firebase_collections.dart';
import '../web_services/firestore_services.dart';
import '../web_services/query_model.dart';
import '../web_services/storage_services.dart';
import 'user_repo.dart';
import 'validations/check_validation.dart';

class EventRepo {
  // // ===========================Singleton Instance================================
  static final EventRepo _instance = EventRepo._internal();
  EventRepo._internal();
  factory EventRepo() => _instance;

  // // ===========================Properties================================
  // List<EventModel> _events = [];
  // List<EventModel> get events => _events;

  // ===========================Mutable API Methods================================
  Future<EventModel> createEvent({
    required String eventTitle,
    required List<String> imageUrls,
    DateTime? dateTime,
    LocationModel? location,
    String? description,
    String? maxPersons,
    required String uuid,
    required OtherUserModel user,
  }) async {
    try {
      await CheckVaidation.onCreateEvent(
        images: imageUrls,
        title: eventTitle,
        dateTime: dateTime,
        location: location,
        maxPersons: maxPersons,
      );

      final EventModel event = EventModel(
        id: uuid,
        creatorDetail: user,
        createdAt: DateTime.now(),
        imageUrls: imageUrls,
        title: eventTitle,
        dateTime: dateTime!,
        location: location!,
        description: description,
        maxPersons: int.tryParse(maxPersons!) ?? 0,
        joinMemberDetails: [],
        joinMemberIds: [],
        createdBy: user.uid,
      );
      final map = event.toMap();
      map['position'] = GeoFlutterFire()
          .point(latitude: location.latitude, longitude: location.longitude)
          .data;

      final Map<String, dynamic> mapped = await FirestoreService()
          .saveWithDocId(
              path: FIREBASE_COLLECTION_EVENTS, data: map, docId: uuid);
      return EventModel.fromMap(mapped);
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  /// Delete Event
  Future<void> deleteEvent({required String eventId}) async {
    try {
      await FirestoreService()
          .delete(collection: FIREBASE_COLLECTION_EVENTS, docId: eventId);
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  /// Update Event
  Future<void> updateEvent({
    required String eventTitle,
    required List<String> imageUrls,
    required String uuid,
    DateTime? dateTime,
    LocationModel? location,
    String? description,
    String? maxPersons,
  }) async {
    try {
      await CheckVaidation.onCreateEvent(
        images: imageUrls,
        title: eventTitle,
        dateTime: dateTime,
        location: location,
        maxPersons: maxPersons,
      );

      await FirestoreService().updateWithDocId(
        path: FIREBASE_COLLECTION_EVENTS,
        docId: uuid,
        data: {
          'imageUrls': imageUrls,
          'title': eventTitle,
          'dateTime': Timestamp.fromDate(dateTime!),
          'location': location?.toMap(),
          'description': description,
          'maxPersons': int.tryParse(maxPersons ?? "0") ?? 0,
          'position': GeoFlutterFire()
              .point(
                  latitude: location?.latitude ?? 0,
                  longitude: location?.longitude ?? 0)
              .data,
        },
      );
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  /// Upload Images
  Future<String?> uploadImage(
      {required String imageUrl, required String eventId}) async {
    try {
      final String downloadedUrl = await StorageService().uploadImage(
          withFile: File(imageUrl),
          collectionPath:
              '$FIREBASE_COLLECTION_EVENTS/$eventId/${DateTime.now().microsecondsSinceEpoch}');
      return downloadedUrl;
    } catch (e) {
      log("[debug uploadImageError] ${e.toString}");
      return null;
    }
  }

  /// Join Event
  Future<OtherUserModel> joinEvent({required String eventId}) async {
    try {
      final UserModel user = UserRepo().currentUser;
      final OtherUserModel otherUser = OtherUserModel(
        uid: user.uid,
        name: user.name,
        avatarUrl: user.avatar,
        createdAt: DateTime.now(),
        about: user.bio,
      );

      await FirestoreService().updateWithDocId(
          path: FIREBASE_COLLECTION_EVENTS,
          data: {
            "joinMemberDetails": FieldValue.arrayUnion([otherUser.toMap()]),
            "joinMemberIds": FieldValue.arrayUnion([user.uid]),
          },
          docId: eventId);
      return otherUser;
    } catch (e) {
      log("[debug JoinEventError] ${e.toString}");
      throw throwAppException(e: e);
    }
  }

  // ===========================Immutable APIs================================
  Future<List<EventModel>> fetchEventsWith({String? withUserId}) async {
    try {
      final List<QueryModel> queries = [];
      if (withUserId != null) {
        queries.add(QueryModel(
            field: 'createdBy', value: withUserId, type: QueryType.isEqual));
      }
      queries.add(
          QueryModel(field: 'createdAt', value: true, type: QueryType.orderBy));
      final List<Map<String, dynamic>> data = await FirestoreService()
          .fetchWithMultipleConditions(
              collection: FIREBASE_COLLECTION_EVENTS, queries: queries);
      return data.map((e) => EventModel.fromMap(e)).toList();
    } catch (e) {
      log(e.toString());
      throw throwAppException(e: e);
    }
  }

  /// Fetch All Events
  /// Fetch All Events Within Radius
  Future<List<EventModel>> fetchAllEvents({
    required double userLat,
    required double userLng,
    EventModel? lastEvent,
  }) async {
    try {
      final String userId = UserRepo().currentUser.uid;
      final geoflutterfire = GeoFlutterFire();
      final center =
          geoflutterfire.point(latitude: userLat, longitude: userLng);

      Query collectionReference =
          FirebaseFirestore.instance.collection(FIREBASE_COLLECTION_EVENTS);
      final Stream<List<DocumentSnapshot>> stream =
          geoflutterfire.collection(collectionRef: collectionReference).within(
                center: center,
                radius: 5, // IN Killo Meters
                field: 'position',
              );

      final List<DocumentSnapshot> documents = await stream.first;

      // Filter documents to ensure they are within the radius
      final List<Map<String, dynamic>?> maps =
          documents.map((e) => (e.data() as Map<String, dynamic>?)).toList();

      final List<EventModel> events = maps
          .where((data) => data != null)
          .toList()
          .map((e) => EventModel.fromMap(e!))
          .where((element) => element.createdBy != userId)
          .toList();
      events.sort((a, b) => b.createdAt.millisecondsSinceEpoch
          .compareTo(a.createdAt.millisecondsSinceEpoch));
      return events;
    } catch (e) {
      debugPrint("[debug EventFetchAll] $e");
      throw throwAppException(e: e);
    }
  }

  Future<EventModel?> fetchWith({required String eventid}) async {
    try {
      final Map<String, dynamic>? data = await FirestoreService()
          .fetchSingleRecord(path: FIREBASE_COLLECTION_EVENTS, docId: eventid);
      if (data != null) {
        return EventModel.fromMap(data);
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
