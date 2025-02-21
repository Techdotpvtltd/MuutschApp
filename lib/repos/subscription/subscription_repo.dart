// Project: 	   listi_shop
// File:    	   subscription_repo
// Path:    	   lib/repos/subscription_repo.dart
// Author:       Ali Akbar
// Date:        28-05-24 16:49:07 -- Tuesday
// Description:

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:musch/manager/store_manager.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../exceptions/exception_parsing.dart';
import '../../models/subscription_model.dart';
import '../../utils/constants/firebase_collections.dart';
import '../../web_services/firestore_services.dart';
import '../../web_services/query_model.dart';
import '../user_repo.dart';

class SubscriptionRepo {
  // ===========================Singleton InStance================================
  static final SubscriptionRepo _instance = SubscriptionRepo._internal();
  SubscriptionRepo._internal();
  factory SubscriptionRepo() => _instance;
  // ===========================Properties================================
  SubscriptionModel? _subscription;
  SubscriptionModel? get lastSubscription => _subscription;

  // ===========================API Methods================================

  Future<void> saveSubscription({required Package purchase}) async {
    try {
      final String id = storeManager.active?.productIdentifier ?? "";

      final int period = id.contains("1")
          ? 1
          : id.contains("3")
              ? 3
              : id.contains('6')
                  ? 6
                  : 1;
      final DateTime startDate = DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(storeManager.active?.latestPurchaseDate ?? "0") ?? 0);

      final DateTime endDate = DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(storeManager.active?.expirationDate ?? "0") ?? 0);

      final SubscriptionModel model = SubscriptionModel(
        id: "",
        periodDuration: period.toString(),
        productId: id,
        startTime: startDate,
        endTime: endDate,
        subscribedBy: UserRepo().currentUser.uid,
        title: "Premium for ${period} ${period > 1 ? "months" : "month"}",
        purchaseId: "",
      );
      final Map<String, dynamic> map = await FirestoreService()
          .saveWithSpecificIdFiled(
              path: FIREBASE_COLLECTION_SUBSCRIPTIONS,
              data: model.toMap(),
              docIdFiled: 'id');
      _subscription = SubscriptionModel.fromMap(map);
      await _validateSubscription();
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  Future<void> getLastSubscription() async {
    try {
      final List<Map<String, dynamic>> mapped =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_SUBSCRIPTIONS,
        queries: [
          QueryModel(
              field: "subscribedBy",
              value: UserRepo().currentUser.uid,
              type: QueryType.isEqual),
          QueryModel(field: "endTime", value: true, type: QueryType.orderBy),
          QueryModel(field: "", value: 1, type: QueryType.limit),
        ],
      );

      if (mapped.isNotEmpty) {
        _subscription = SubscriptionModel.fromMap(mapped.first);
        await _validateSubscription();
        debugPrint(_subscription.toString());
      }
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  Future<void> _validateSubscription() async {
    log("${storeManager.hasSubscription}", name: "Active Subscription");
  }

  void clearLastSubscription() => _subscription = null;
}
