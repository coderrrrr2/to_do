import UIKit
import Flutter
import flutter_local_notifications
import flutter_timezone

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Set up the plugin registrant callback for FlutterLocalNotificationsPlugin
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
