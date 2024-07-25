import UIKit
import Flutter
import GoogleMaps

import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAqSjBWxORHHKlLY7ISV5BmookK7fQlw4U")
    GeneratedPluginRegistrant.register(with: self)
      if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

extension AppDelegate {
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Check the notification content
        
//        let notificationType = notification.request.content.userInfo["type"] as? String ?? ""
//            if(notificationType == "message") {
//            completionHandler([])
//            return;
//    }
    
    completionHandler([.alert, .sound, .badge])
}
}
