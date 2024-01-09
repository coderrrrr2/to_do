import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsInitializer {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Private constructor to prevent instantiation
  LocalNotificationsInitializer._();

  // Singleton instance
  static final LocalNotificationsInitializer _instance =
      LocalNotificationsInitializer._();

  factory LocalNotificationsInitializer() {
    return _instance;
  }

  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin {
    return _flutterLocalNotificationsPlugin;
  }

  Future<void> initializePlugins() async {
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      // ...
      notificationCategories: [
        DarwinNotificationCategory(
          'taskCategory',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain(
              'dismissAction',
              'Dismiss',
              options: <DarwinNotificationActionOption>{},
            ),
            DarwinNotificationAction.plain(
              'finishAction',
              'Mark as Finished',
              options: <DarwinNotificationActionOption>{},
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        )
      ],
    );
    // Perform the initialization steps
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // Add other methods for managing notifications, e.g., sendNotification, etc.
}
