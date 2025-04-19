import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/config/theme/theme_config.dart';
import 'package:muslim/src/presentation/controllers/translations_controller.dart';

import '../config/firebase/firebase_options.dart';
import '../config/hive_service.dart';

class Setting {
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await HiveService.instance.init();
    TranslationsController translationsController = Get.put(
      TranslationsController(),
      permanent: true,
    );

    Get.put(ThemeController(), permanent: true);
    await translationsController.initLanguage();
  }
}
