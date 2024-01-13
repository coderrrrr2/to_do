import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/services/local%20Notifications/local_notifications_initialiser.dart';

final StreamController<LocalNotificationsService>
    didReceiveLocalNotificationStream =
    StreamController<LocalNotificationsService>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

MethodChannel platform =
    const MethodChannel('dexterx.dev/flutter_local_notifications_example');

String portName = 'notification_send_port';
String darwinNotificationCategoryPlain = 'plainCategory';

class LocalNotificationsService {
  LocalNotificationsService._();

  static final LocalNotificationsService _instance =
      LocalNotificationsService._();

  factory LocalNotificationsService() {
    return _instance;
  }

  var flutterLocalNotificationsPlugin =
      LocalNotificationsInitializer().flutterLocalNotificationsPlugin;

  void initialiseTimeZones() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(await getTimeZone()));
  }

  Future<void> _showNotificationWithActions(ToDo todo) async {
    var androidNotificationDetails = const AndroidNotificationDetails(
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      '...',
      '...',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('id_1', 'Mark as Finished'),
        AndroidNotificationAction('id_2', 'Dismissed'),
      ],
    );
    DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(todo.id as int, 'Due task',
        '${todo.taskName} is  due', notificationDetails,
        payload: 'succesful');
  }

  Future<String> getTimeZone() async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    return currentTimeZone;
  }

  Future<List<PendingNotificationRequest>>
      retrievePendingNotificationsRequest() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  Future<List<ActiveNotification>> retrieveactiveNotifications() async {
    return await flutterLocalNotificationsPlugin.getActiveNotifications();
  }

  void scheduleNotifications(ToDo todo) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void showPermissionDialog() {
    if (Platform.isAndroid) {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    } else if (Platform.isIOS) {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions(alert: true, badge: true, sound: true);
    }
  }
}
