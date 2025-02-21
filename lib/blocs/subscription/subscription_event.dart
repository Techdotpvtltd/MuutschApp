// Project: 	   listi_shop
// File:    	   subscription_event
// Path:    	   lib/blocs/subscription/subscription_event.dart
// Author:       Ali Akbar
// Date:        02-05-24 16:33:33 -- Thursday
// Description:

import 'package:purchases_flutter/purchases_flutter.dart';

abstract class SubscriptionEvent {}

// Get Ready Subscription Event
class SubscriptionEventReady extends SubscriptionEvent {}

class SubscriptionEventFetechProducts extends SubscriptionEvent {}

class SubscriptionEventBuySubscription extends SubscriptionEvent {
  final Package package;

  SubscriptionEventBuySubscription({required this.package});
}

class SubscriptionEventMarkPurchaseCompleted extends SubscriptionEvent {
  final Package package;

  SubscriptionEventMarkPurchaseCompleted({required this.package});
}

// ===========================Get Last Subscription Event================================

class SubscriptionEventGetLast extends SubscriptionEvent {}
