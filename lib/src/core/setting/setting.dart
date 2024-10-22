import 'package:firebase_core/firebase_core.dart';
import 'package:muslim/src/core/config/di/locator.dart';

import '../config/firebase/firebase_options.dart';
import '../config/hive_service.dart';

class Setting {
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await HiveService.instance.init();
    initializeDependencies();
  }
}
