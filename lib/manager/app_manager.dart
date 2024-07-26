// Project: 	   muutsch
// File:    	   app_manager
// Path:    	   lib/manager/app_manager.dart
// Author:       Ali Akbar
// Date:        17-05-24 13:50:16 -- Friday
// Description:

import 'package:geolocator/geolocator.dart';
import 'package:musch/repos/chat_repo.dart';
import 'package:musch/repos/user_repo.dart';

class AppManager {
  static final AppManager _instance = AppManager._internal();

  AppManager._internal();
  factory AppManager() => _instance;

  Position? currentLocationPosition;

  static void clearAll() {
    UserRepo().clearAll();
    ChatRepo().clearAll();
  }
}
