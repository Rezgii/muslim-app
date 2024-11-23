import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:muslim/src/core/config/flutter_local_notification.dart';
import 'package:muslim/src/core/config/locale/local.dart';
import 'package:muslim/src/core/config/theme/theme_config.dart';
import 'package:muslim/src/core/setting/setting.dart';
import 'package:muslim/src/presentation/controllers/translations_controller.dart';
import 'package:muslim/src/presentation/screens/splash_screen.dart';
// import 'package:workmanager/workmanager.dart';
// import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeNotifications();
  // tz.initializeTimeZones();
  // Workmanager().initialize(
  //     callbackDispatcher, // The top level function, aka callbackDispatcher
  //     isInDebugMode:
  //         true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  //     );
  await Setting.init();
  runApp(const MyApp());
}

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     // Schedule notifications or play Adhan
//     // final DateTime now = DateTime.now();
//     // Fetch next prayer time dynamically and schedule notifications.
//     // Call `scheduleAdhanNotification` here.
//     // scheduleAdhanNotification(adhanTime, prayerName);
//     return Future.value(true);
//   });
// }

// void scheduleBackgroundTask() {
//   Workmanager().registerPeriodicTask(
//     'adhan_notification_task',
//     'adhanTask',
//     frequency: const Duration(minutes: 15), // Adjust as needed
//     // inputData: {}, // Pass prayer times or other data if necessary
//   );
// }

// void updateNextPrayer() {
//   DateTime now = DateTime.now();
//   DateTime? nextPrayerDateTime;
//   String? nextPrayerName;

//     todayPrayer.prayersTime.forEach((name, time) {
//       DateTime prayerDateTime = _parsePrayerTime(time);
//       if (prayerDateTime.isBefore(now) &&
//           name != 'Sunset' &&
//           name != 'Imsak' &&
//           name != 'Firstthird' &&
//           name != 'Lastthird' &&
//           name != 'Midnight') {
//         Duration passedDuration = DateTime.now().difference(prayerDateTime);
//         if (passedDuration.inMinutes < 30) {
//           nextPrayerDateTime = prayerDateTime;
//           nextPrayerName = name;
//         }
//       } else if (prayerDateTime.isAfter(now) &&
//           name != 'Sunset' &&
//           name != 'Imsak' &&
//           name != 'Firstthird' &&
//           name != 'Lastthird' &&
//           name != 'Midnight') {
//         if (nextPrayerDateTime == null ||
//             prayerDateTime.isBefore(nextPrayerDateTime!)) {
//           nextPrayerDateTime = prayerDateTime;
//           nextPrayerName = name;
//         }
//       }
//     });

//     if (nextPrayerDateTime == null) {
//       now = now.add(const Duration(days: 1));
//       todayPrayer = PrayerTimeModel.fromMap(HiveService.instance
//               .getPrayerTimes('yearlyPrayerTime')[now.month.toString()]
//           [now.day - 1]);
//       nextPrayerName = todayPrayer.prayersTime.keys.first;
//       nextPrayerDateTime =
//           _parsePrayerTime(todayPrayer.prayersTime[nextPrayerName]!);
//     }

//     if (nextPrayerName != null && nextPrayerDateTime != null) {
//       prayerName = nextPrayerName!;
//       prayerTime = _formatTime(nextPrayerDateTime!);
//     }
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
