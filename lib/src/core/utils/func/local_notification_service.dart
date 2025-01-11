import 'dart:async';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);

class LocalNotificationService {
  //Setup Notification
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static StreamController<NotificationResponse> streamController =
      StreamController();

  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: DarwinInitializationSettings());

    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {},
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await AndroidFlutterLocalNotificationsPlugin()
        .requestExactAlarmsPermission();
  }

  static int generateIdFromDateTime(DateTime dateTime) {
    return int.parse(
      "${dateTime.day.toString().padLeft(2, '0')}"
      "${dateTime.hour.toString().padLeft(2, '0')}"
      "${dateTime.minute.toString().padLeft(2, '0')}"
      "${dateTime.second.toString().padLeft(2, '0')}", // Adding seconds
    );
  }

  //Show Basic Notification
  static Future<void> basicNotification(
      {required String title, required String body, String? payload}) async {
    NotificationDetails details = const NotificationDetails(
      android: AndroidNotificationDetails(
        //Configure notif here
        "id 1",
        "Basic Notif",
        importance: Importance.max,
        priority: Priority.max,
        // sound: RawResourceAndroidNotificationSound("adhan"),
        category: AndroidNotificationCategory.alarm,
        playSound: true,
      ),
    );
    await flutterLocalNotificationsPlugin.show(
      generateIdFromDateTime(DateTime.now()),
      // 0,
      title,
      body,
      details,
      payload: payload,
    );
  }

  //Show Repeated Notification
  static Future<void> repeatedNotification(
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
  static Future<void> scheduledNotification(
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
        playSound: true,
      ),
    );
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    log("Scheduled $title at ${tz.TZDateTime(tz.local, time.year, time.month, time.day, time.hour, time.minute)}");
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

  //Show Daily Scheduled Notification
  static Future<void> scheduledDailyNotification(
      {required String title,
      required String body,
      required DateTime time,
      required int hour,
      required int minute,
      String? payload}) async {
    NotificationDetails details = const NotificationDetails(
      android: AndroidNotificationDetails(
        //Configure notif here
        "id 4",
        "Daily Scheduled Notif",
        importance: Importance.max,
        priority: Priority.max,
        // sound: RawResourceAndroidNotificationSound("adhan"),
        category: AndroidNotificationCategory.alarm,
        playSound: true,
      ),
    );
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Algiers'));
    var currentTime = tz.TZDateTime.now(tz.local);
    var scheduleTime = tz.TZDateTime(tz.local, currentTime.year,
        currentTime.month, currentTime.day, hour, minute);
    if (scheduleTime.isBefore(currentTime)) {
      scheduleTime = scheduleTime.add(const Duration(days: 1));
    }
    log("The Current Time is : ${currentTime.year}/${currentTime.month}/${currentTime.day} - ${currentTime.hour}:${currentTime.minute}");
    log("The Schdeuled Time of is : ${scheduleTime.year}/${scheduleTime.month}/${scheduleTime.day} - ${scheduleTime.hour}:${scheduleTime.minute}");
    await flutterLocalNotificationsPlugin.zonedSchedule(
      generateIdFromDateTime(time),
      title,
      body,
      payload: payload,
      scheduleTime,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  //Cancel Notification
  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  //Cancel All Notifications
  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> retrievPendingNotif() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    log("Pending Notif Are");
    for (PendingNotificationRequest pendingNotif
        in pendingNotificationRequests) {
      log(pendingNotif.title.toString());
      log(pendingNotif.body.toString());
      log(pendingNotif.id.toString());
    }
  }

  static void retrieveActiveNotif() async {
    final List<ActiveNotification> activeNotifications =
        await flutterLocalNotificationsPlugin.getActiveNotifications();
    log("Active Notif Are");
    log(activeNotifications.toString());
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  //onTap Notif (forground & background only)
}

  // 0. Ask Permission [Done]
  // 1. Setup [Done]
  // 2. Basic Notification [Done]
  // 3. Repeated Notification [Done]
  // 4. Scheduled Notification [Done]
  // 5. Custom Sound [Done]
  // 6. on Tap Notif [Done]
  // 7. Daily NOtif at Specific Time [Done]
  // 8. Real Example [Done]