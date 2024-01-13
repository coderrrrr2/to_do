import UIKit
import Flutter
import flutter_local_notifications

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Set up the plugin registrant callback for FlutterLocalNotificationsPlugin
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }

    // Your other setup code...

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
