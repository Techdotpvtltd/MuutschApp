// Project: 	   listi_shop
// File:    	   subscription_bloc
// Path:    	   lib/blocs/subscription/subscription_bloc.dart
// Author:       Ali Akbar
// Date:        02-05-24 16:41:04 -- Thursday
// Description:

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musch/manager/store_manager.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

import '../../exceptions/app_exceptions.dart';
import '../../repos/subscription/subscription_repo.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc() : super(SubscriptionStateInitial()) {
    on<SubscriptionEventGetLast>(
      (event, emit) async {
        try {
          emit(SubscriptionStateGettingLast());
          await SubscriptionRepo().getLastSubscription();
          emit(SubscriptionStateGotLast());
          storeManager.restore(); // Check for previous purchases
        } on AppException catch (e) {
          emit(SubscriptionStateGotLast());
          log("[debug GetLastSubscription] ${e.message.toString()}");
        }
      },
    );

    /// OnReady Subscription Event
    on<SubscriptionEventReady>(
      (event, emit) async {
        try {
          emit(SubscriptionStateGettingProducts());
          final List<Package> products = await storeManager.availablePackages;
          emit(SubscriptionStateGotProducts(products: products));
        } on AppException catch (e) {
          emit(SubscriptionStateFailure(exception: e));
        }
      },
    );

    // onPurchase Subscription Event
    on<SubscriptionEventBuySubscription>(
      (event, emit) async {
        try {
          emit(SubscriptionStatePurchasing());
          await storeManager.purchase(event.package);
          emit(SubscriptionStatePurchased());
        } on AppException catch (e) {
          emit(SubscriptionStatePurchaseFailure(exception: e));
        }
      },
    );
  }

  Future<void> verifyAndDeliverProduct() async {
    try {
      // final int? lastSubscriptionStartDate =
      //     SubscriptionRepo().lastSubscription?.startTime.millisecondsSinceEpoch;
      // final int transcationDate =
      //     int.tryParse(purchaseDetails.transactionDate ?? "0") ?? 0;

      // if (lastSubscriptionStartDate == null) {
      //   return;
      // }

      // if (transcationDate != lastSubscriptionStartDate) {
      //   final bool isRecentRenewal =
      //       DateTime.fromMillisecondsSinceEpoch(transcationDate).isAfter(
      //           DateTime.fromMillisecondsSinceEpoch(lastSubscriptionStartDate));
      //   if (isRecentRenewal) {
      //     log("Saving....");
      //     await SubscriptionRepo().saveSubscription(purchase: purchaseDetails);
      //   }
      // }
    } catch (e) {
      rethrow;
    }
  }
}
