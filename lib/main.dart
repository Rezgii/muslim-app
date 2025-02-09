import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  //Show Reminder
  Workmanager().executeTask((task, inputData) async {
    try {
      //The background task code goes here
      log("========Reminders========");
      LocalNotificationService.scheduledDailyNotification(
          title: 'تذكير',
          body: 'حان وقت أذكار الصباح',
          time: DateTime.now(),
          hour: 06,
          minute: 00);
      log("Scheduled Reminder At 06:00 AM");
      LocalNotificationService.scheduledDailyNotification(
          title: 'تذكير',
          body: 'حان وقت أذكار المساء',
          time: DateTime.now(),
          hour: 18,
          minute: 00);
      log("Scheduled Reminder At 06:00 PM");
    } catch (e) {
      log(e.toString());
    }

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseNotification.instance.initNotifications();
  await LocalNotificationService.init();
  await Setting.init();
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
  //Register Task
  await Workmanager().registerPeriodicTask(
    "athkar_reminder",
    "scheduleAthkarReminder",
    frequency: const Duration(hours: 23),
    initialDelay: const Duration(minutes: 1),
  );
  //TODO: Foreground Service

  // ForeGroundService.instance.initCommunicationPort();
  // ForeGroundService.instance.initService();
  runApp(const MyApp());
}

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
