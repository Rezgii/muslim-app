import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:muslim/src/data/models/user_model.dart';
import 'package:muslim/src/presentation/controllers/translations_controller.dart';

import '../config/firebase/firebase_options.dart';
import '../config/hive_service.dart';

class Setting {
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await HiveService.instance.init();
    // settingBox = await Hive.openBox('setting');
    TranslationsController translationsController =
        Get.put(TranslationsController(), permanent: true);
    await translationsController.initLanguage();
  }
}
