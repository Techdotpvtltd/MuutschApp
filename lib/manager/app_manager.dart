// Project: 	   muutsch
// File:    	   app_manager
// Path:    	   lib/manager/app_manager.dart
// Author:       Ali Akbar
// Date:        17-05-24 13:50:16 -- Friday
// Description:

import 'package:geolocator/geolocator.dart';

class AppManager {
  static final AppManager _instance = AppManager._internal();

  AppManager._internal();
  factory AppManager() => _instance;

  Position? currentLocationPosition;
}
