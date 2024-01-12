import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsService {
  LocalNotificationsService._();

  static final LocalNotificationsService _instance =
      LocalNotificationsService._();

  factory LocalNotificationsService() {
    return _instance;
  }

  Future<void> showNotificationsWithActions(Platform platform) async {
    var notificationDetails;
    if (platform == Platform.isAndroid) {
      notificationDetails = const AndroidNotificationDetails(
        '...',
        '...',
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction('id_1', 'Action 1'),
          AndroidNotificationAction('id_2', 'Action 2'),
          AndroidNotificationAction('id_3', 'Action 3'),
        ],
      );
    }

    if (platform == Platform.isIOS) {}
  }
}
