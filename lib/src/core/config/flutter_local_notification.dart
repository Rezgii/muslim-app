import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings(
          '@mipmap/ic_launcher'); // Replace with your app icon.

  const DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings();

  const InitializationSettings settings =
      InitializationSettings(android: androidSettings, iOS: iosSettings);

  await flutterLocalNotificationsPlugin.initialize(settings);
}

Future<void> scheduleAdhanNotification(
    DateTime adhanTime, String prayerName) async {
  // Check if notifications are granted

  var status = await Permission.notification.status;
  if (status.isDenied) {
    // We haven't asked for permission yet or the permission has been denied before, but not permanently.
    await Permission.notification.request();
  }

  if (await Permission.notification.isPermanentlyDenied) {
    // The user opted to never again see the permission request dialog for this
    // app. The only way to change the permission's status now is to let the
    // user manually enables it in the system settings.
    openAppSettings();
  }

  // Initialize timezone data
  tz.initializeTimeZones();

  // Convert adhanTime to time-zone aware datetime
  final tz.TZDateTime tzAdhanTime = tz.TZDateTime.from(adhanTime, tz.local);

  // Define Android notification details
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'adhan_channel', // Channel ID
    'Adhan Notifications', // Channel Name
    channelDescription: 'Notifies at prayer times',
    importance: Importance.max,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound('adhan'), // Android sound
  );

  // Define iOS notification details
  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    sound: 'adhan', // Sound name (not full path)
  );

  // Combine notification details
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails, iOS: iosDetails);

  // Schedule the notification
  await flutterLocalNotificationsPlugin.zonedSchedule(
    androidScheduleMode: AndroidScheduleMode.exact,
    DateTime.now().millisecondsSinceEpoch % 100000, // Unique ID for each prayer
    'Adhan',
    "It's time for $prayerName",
    tzAdhanTime, // Time-zone aware time
    notificationDetails,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}
