import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/config/hive_service.dart';

class TranslationsController extends GetxController {
  List<String> _languages = [];
  String? _currentLanguage;
  late Locale mylocale;
  get currentLanguage => _currentLanguage;
  get languages => _languages;

  changeLanguage(String lang) {
    Locale locale;
    _currentLanguage = lang;
    switch (lang) {
      case 'EN':
        _languages = ['FR', 'AR'];
        locale = const Locale('en', 'US');
        break;
      case 'FR':
        _languages = ['AR', 'EN'];
        locale = const Locale('fr', 'FR');
        break;
      case 'AR':
        _languages = ['FR', 'EN'];
        locale = const Locale('ar', 'AE');
        break;
      default:
        _languages = [];
        locale = const Locale('ar', 'AE');
    }
    mylocale = locale;
    Get.updateLocale(locale);
    debugPrintSynchronously(Get.locale.toString());
    update();
  }

  initLanguage() {
    _currentLanguage = HiveService.instance.settingsBox.get("lang") ?? 'EN';
    changeLanguage(_currentLanguage!);
  }
}
