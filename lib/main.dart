import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/config/firebase/firebase_notification.dart';
import 'package:muslim/src/core/config/firebase/firebase_options.dart';
import 'package:muslim/src/core/config/locale/local.dart';
import 'package:muslim/src/core/config/theme/theme_config.dart';
import 'package:muslim/src/core/setting/setting.dart';
import 'package:muslim/src/core/utils/func/local_notification_service.dart';
import 'package:muslim/src/presentation/controllers/translations_controller.dart';
import 'package:muslim/src/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseNotification.instance.initNotifications();
  await LocalNotificationService.init();
  await Setting.init();
  // await Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode: false,
  // );
  // //Register Task
  // await Workmanager().registerPeriodicTask(
  //   "athkar_reminder",
  //   "scheduleAthkarReminder",
  //   frequency: const Duration(hours: 23),
  //   initialDelay: const Duration(minutes: 1),
  // );
  //TODO: Foreground Service

  // ForeGroundService.instance.initCommunicationPort();
  // ForeGroundService.instance.initService();
  runApp(const MyApp());

  // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

// Future<void> initPlatformState() async {
//   // Configure BackgroundFetch.
//   int status = await BackgroundFetch.configure(
//     BackgroundFetchConfig(
//       minimumFetchInterval: 15,
//       stopOnTerminate: false,
//       enableHeadless: true,
//       requiresBatteryNotLow: false,
//       requiresCharging: false,
//       requiresStorageNotLow: false,
//       requiresDeviceIdle: false,
//       requiredNetworkType: NetworkType.NONE,
//     ),
//     (String taskId) async {
//       // <-- Event handler
//       // This is the fetch-event callback.
//       log("[BackgroundFetch] Event received $taskId");

//       // IMPORTANT:  You must signal completion of your task or the OS can punish your app
//       // for taking too long in the background.
//       BackgroundFetch.finish(taskId);
//     },
//     (String taskId) async {
//       // <-- Task timeout handler.
//       // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
//       log("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
//       BackgroundFetch.finish(taskId);
//     },
//   );
//   log('[BackgroundFetch] configure success: $status');
// }

@pragma('vm:entry-point')
void notificationTapBackground(
  NotificationResponse notificationResponse,
) async {
  if (notificationResponse.actionId == 'btn_stop_adhan') {
    log('Pressed btn Stop Adhan');
    // await stopAdhanSound();
  }
}

// @pragma('vm:entry-point')
// void backgroundFetchHeadlessTask(HeadlessTask task) async {
//   String taskId = task.taskId;
//   bool isTimeout = task.timeout;
//   if (isTimeout) {
//     // This task has exceeded its allowed running-time.
//     // You must stop what you're doing and immediately .finish(taskId)
//     log("[BackgroundFetch] Headless task timed-out: $taskId");
//     BackgroundFetch.finish(taskId);
//     return;
//   }
//   log('[BackgroundFetch] Headless event received.');
//   // Do your work here...
//   log("========Reminders========");
//   LocalNotificationService.scheduledDailyNotification(
//     title: 'تذكير',
//     body: 'حان وقت أذكار الصباح',
//     time: DateTime.now(),
//     hour: 06,
//     minute: 00,
//   );
//   log("Scheduled Reminder At 06:00 AM");
//   LocalNotificationService.scheduledDailyNotification(
//     title: 'تذكير',
//     body: 'حان وقت أذكار المساء',
//     time: DateTime.now(),
//     hour: 18,
//     minute: 00,
//   );
//   log("Scheduled Reminder At 06:00 PM");
//   BackgroundFetch.finish(taskId);
// }

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   //Show Reminder
//   Workmanager().executeTask((task, inputData) async {
//     try {
//       //The background task code goes here
//       log("========Reminders========");
//       LocalNotificationService.scheduledDailyNotification(
//           title: 'تذكير',
//           body: 'حان وقت أذكار الصباح',
//           time: DateTime.now(),
//           hour: 06,
//           minute: 00);
//       log("Scheduled Reminder At 06:00 AM");
//       LocalNotificationService.scheduledDailyNotification(
//           title: 'تذكير',
//           body: 'حان وقت أذكار المساء',
//           time: DateTime.now(),
//           hour: 18,
//           minute: 00);
//       log("Scheduled Reminder At 06:00 PM");
//     } catch (e) {
//       log(e.toString());
//     }

//     return Future.value(true);
//   });
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TranslationsController controller = Get.find<TranslationsController>();

    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          translations: LocalStrings(),
          debugShowCheckedModeBanner: false,
          theme: ThemeConfig.darkTheme,
          title: 'Muslim',
          locale: controller.mylocale,
          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}
