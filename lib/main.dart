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

  runApp(const MyApp());
}

@pragma('vm:entry-point')
void notificationTapBackground(
  NotificationResponse notificationResponse,
) async {
  if (notificationResponse.actionId == 'btn_stop_adhan') {
    log('Pressed btn Stop Adhan');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TranslationsController controller = Get.find<TranslationsController>();
    ThemeController themeController = Get.find<ThemeController>();

    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
            translations: LocalStrings(),
            debugShowCheckedModeBanner: false,
            theme: themeController.lightTheme,
            darkTheme: themeController.darkTheme,
            themeMode: ThemeMode.dark,
            title: 'Muslim',
            locale: controller.mylocale,
            home: child,
          )
        ;
      },
      child: const SplashScreen(),
    );
  }
}
