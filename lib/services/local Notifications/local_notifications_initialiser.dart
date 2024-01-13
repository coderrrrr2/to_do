import 'dart:developer';
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

  void initialisePlugin(InitializationSettings initializationSettings) async {
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      // ...
    }, onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
  }

  Future<void> initializeNotificationCategories() async {
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      // ...  requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
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
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      '...',
      '...',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('id_1', 'Action 1'),
        AndroidNotificationAction('id_2', 'Action 2'),
      ],
    );
    const NotificationDetails(android: androidNotificationDetails);

    initialisePlugin(initializationSettings);
  }

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    // handle action
  }
  void notificationResponse(NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      log('notification payload: $payload');
    }

    // Add other methods for managing notifications, e.g., sendNotification, etc.
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  }
}
