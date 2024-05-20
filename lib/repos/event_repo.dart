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

import '../exceptions/app_exceptions.dart';
import '../exceptions/exception_parsing.dart';
import '../models/event_model.dart';
import '../models/join_event_model.dart';
import '../models/location_model.dart';
import '../utils/constants/firebase_collections.dart';
import '../web_services/firestore_services.dart';
import '../web_services/query_model.dart';
import '../web_services/storage_services.dart';
import 'user_repo.dart';
import 'validations/check_validation.dart';

class EventRepo {
  // // ===========================Singleton Instance================================
  // static final EventRepo _instance = EventRepo._internal();
  // EventRepo._internal();
  // factory EventRepo() => _instance;

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
    required String userId,
    required String uuid,
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
        createdBy: userId,
        createdAt: DateTime.now(),
        imageUrls: imageUrls,
        title: eventTitle,
        dateTime: dateTime!,
        location: location!,
        description: description,
        maxPersons: int.tryParse(maxPersons!) ?? 0,
      );
      final Map<String, dynamic> mapped = await FirestoreService()
          .saveWithDocId(
              path: FIREBASE_COLLECTION_EVENTS,
              data: event.toMap(),
              docId: uuid);
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
  Future<JoinEventModel> joinEvent({
    required String eventId,
  }) async {
    try {
      final String userId = UserRepo().currentUser.uid;
      final JoinEventModel eventModel = JoinEventModel(
          uuid: "",
          joinerId: userId,
          joinTime: DateTime.now(),
          eventId: eventId);
      final Map<String, dynamic> data = await FirestoreService()
          .saveWithSpecificIdFiled(
              path: FIREBASE_COLLECTION_JOIN_EVENTS,
              data: eventModel.toMap(),
              docIdFiled: 'uuid');
      return JoinEventModel.fromMap(data);
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
      debugPrint(e.toString());
      throw throwAppException(e: e);
    }
  }

  /// Fetch All Events
  Future<void> fetchAllEvents({
    required Function(AppException) onError,
    required Function(EventModel) onEventRecieved,
    required VoidCallback onAllGet,
  }) async {
    final String userId = UserRepo().currentUser.uid;

    await FirestoreService().fetchWithListener(
      collection: FIREBASE_COLLECTION_EVENTS,
      onError: (e) {
        onError(throwAppException(e: e));
      },
      onAdded: (data) {
        final EventModel event = EventModel.fromMap(data);
        onEventRecieved(event);
      },
      onRemoved: (p0) {},
      onUpdated: (p0) {},
      onAllDataGet: () {
        onAllGet();
      },
      onCompleted: (listener) {
        listener?.cancel();
      },
      queries: [
        QueryModel(field: 'createdAt', value: true, type: QueryType.orderBy),
        QueryModel(
            field: 'createdBy', value: userId, type: QueryType.isNotEqual),
      ],
    );
  }

  /// Fetch Joined Members Data

  Future<List<JoinEventModel>> fetchJoinEvent({required String eventId}) async {
    try {
      final List<Map<String, dynamic>> data =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_JOIN_EVENTS,
        queries: [
          QueryModel(field: 'eventId', value: eventId, type: QueryType.isEqual),
        ],
      );

      return data.map((e) => JoinEventModel.fromMap(e)).toList();
    } catch (e) {
      log("[debug JoinFetchEventError] ${e.toString}");
      throw throwAppException(e: e);
    }
  }
}
