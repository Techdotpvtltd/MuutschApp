// Project: 	   muutsch
// File:    	   local_storage_services
// Path:    	   lib/services/local_storage_services/local_storage_services.dart
// Author:       Ali Akbar
// Date:        09-06-24 11:54:38 -- Sunday
// Description:

import 'package:musch/utils/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageServices {
  Future<List<String>> getNotificationIds() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getStringList(SHARED_PREFERENCES_NOTIFICATION_IDS) ?? [];
  }

  Future<void> saveNotificationIds({required List<String> ids}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final List<String> oldIds = await getNotificationIds();
    oldIds.addAll(ids);
    pref.setStringList(SHARED_PREFERENCES_NOTIFICATION_IDS, oldIds);
  }
}
