import 'package:muslim/src/core/config/hive_service.dart';

class LanguageCacheHelper {
  HiveService hiveService = HiveService.instance;

  Future<void> cacheLanguageCode(String languageCode) async {
    await hiveService.setSetting('chosenLanguage', languageCode);
  }

  Future<String> getCachedLanguageCode() async {
    String? cachedLanguage = await hiveService.getSetting('chosenLanguage');
    if (cachedLanguage != null) {
      return cachedLanguage;
    } else {
      return 'en';
    }
  }
}
