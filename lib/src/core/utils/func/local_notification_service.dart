import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  //Setup Notification
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static StreamController<NotificationResponse> streamController =
      StreamController();

  static onTap(NotificationResponse notificationResponse) {
    //onTap Notif (forground & background only)
  }

  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: DarwinInitializationSettings());

    flutterLocalNotificationsPlugin.initialize(settings,
        onDidReceiveBackgroundNotificationResponse: onTap,
        onDidReceiveNotificationResponse: onTap);
  }

  static int generateIdFromDateTime(DateTime dateTime) {
    return int.parse(
      "${dateTime.day.toString().padLeft(2, '0')}"
      "${dateTime.hour.toString().padLeft(2, '0')}${dateTime.minute.toString().padLeft(2, '0')}",
    );
  }

  //Show Basic Notification
  static void basicNotification(
      {required String title, required String body, String? payload}) async {
    NotificationDetails details = const NotificationDetails(
      android: AndroidNotificationDetails(
        //Configure notif here
        "id 1",
        "Basic Notif",
        importance: Importance.max,
        priority: Priority.max,
        sound: RawResourceAndroidNotificationSound("adhan"),
        category: AndroidNotificationCategory.alarm,
      ),
    );
    await flutterLocalNotificationsPlugin.show(
      // getPrayerNotificationId(DateTime.now()),
      0,
      title,
      body,
      details,
      payload: payload,
    );
  }

  //Show Repeated Notification
  static void repeatedNotification(
      {required String title, required String body, String? payload}) async {
    NotificationDetails details = const NotificationDetails(
      android: AndroidNotificationDetails(
        //Configure notif here
        "id 2",
        "Repeated Notif",
        importance: Importance.max,
        priority: Priority.max,
        sound: RawResourceAndroidNotificationSound("adhan"),
        category: AndroidNotificationCategory.alarm,
      ),
    );
    await flutterLocalNotificationsPlugin.periodicallyShow(
      androidScheduleMode: AndroidScheduleMode.exact,
      // getPrayerNotificationId(DateTime.now()),
      1,
      title,
      body,
      RepeatInterval.everyMinute,
      details,
      payload: payload,
    );
  }

//Show Scheduled Notification
  static void scheduledNotification(
      {required String title,
      required String body,
      required DateTime time,
      String? payload}) async {
    NotificationDetails details = const NotificationDetails(
      android: AndroidNotificationDetails(
        //Configure notif here
        "id 3",
        "Scheduled Notif",
        importance: Importance.max,
        priority: Priority.max,
        sound: RawResourceAndroidNotificationSound("adhan"),
        category: AndroidNotificationCategory.alarm,
      ),
    );
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    await flutterLocalNotificationsPlugin.zonedSchedule(
      generateIdFromDateTime(time),
      title,
      body,
      payload: payload,
      tz.TZDateTime(
          tz.local, time.year, time.month, time.day, time.hour, time.minute),
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static void cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

  // 0. Ask Permission 
  // 1. Setup [Done]
  // 2. Basic Notification [Done]
  // 3. Repeated Notification [Done]
  // 4. Scheduled Notification [Done]
  // 5. Custom Sound [Done]
  // 6. on Tap Notif [Done]
  // 7. Daily NOtif at Specific Time
  // 8. Real Example