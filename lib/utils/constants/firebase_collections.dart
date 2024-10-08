// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart' show kReleaseMode;

const String FIREBASE_COLLECTION_USER =
    "${kReleaseMode ? "Rel-" : "Dev-"}Users";
const String FIREBASE_COLLECTION_USER_PROFILES =
    "${kReleaseMode ? "Rel-" : "Dev-"}Avatars";
const String FIREBASE_COLLECTION_EVENTS =
    "${kReleaseMode ? "Rel-" : "Dev-"}Events";

const String FIREBASE_COLLECTION_FRIENDS =
    "${kReleaseMode ? "Rel-" : "Dev-"}Friends";
const String FIREBASE_COLLECTION_NOTIFICATION =
    "${kReleaseMode ? "Rel-" : "Dev-"}Notifications";
const String FIREBASE_COLLECTION_CHAT =
    "${kReleaseMode ? "Rel-" : "Dev-"}Chats";

const FIREBASE_COLLECTION_MESSAGES =
    "${kReleaseMode ? "Rel-" : "Dev-"}Messages";
const FIREBASE_COLLECTION_CONTACTS =
    "${kReleaseMode ? "Rel-" : "Dev-"}Contacts";
const FIREBASE_COLLECTION_INTERESTS =
    "${kReleaseMode ? "Rel-" : "Dev-"}Interests";
const FIREBASE_COLLECTION_AGREEMENTS =
    "${kReleaseMode ? "Rel-" : "Dev-"}Agreements";
const String FIREBASE_COLLECTION_SUBSCRIPTIONS =
    "${kReleaseMode ? "Rel-" : "Dev-"}Subscriptions";
