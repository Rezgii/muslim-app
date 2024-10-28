import 'package:hive_flutter/hive_flutter.dart';

// import '../../data/models/user_model.dart';



class HiveService {
  HiveService._();
  static HiveService instance = HiveService._();
  late Box _settingsBox;
  late Box _prayerBox;

  Future<void> init() async {
    try {
      await Hive.initFlutter();
      // Hive.registerAdapter(UserModelAdapter());
      _settingsBox = await Hive.openBox('settings');
      _prayerBox = await Hive.openBox('prayer');

      final settings = {'intro': false, 'darkMode': false};
      for (final entry in settings.entries) {
        if (HiveService.instance.getSetting(entry.key) == null) {
          HiveService.instance.setSetting(entry.key, entry.value);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // Getters for the boxes
  Box get settingsBox => _settingsBox;
  Box get prayerBox => _prayerBox;

  // Dynamic Getters
  dynamic getSetting(String key) => _settingsBox.get(key);
  dynamic getPrayerTimes(String key) => _prayerBox.get(key);

  // Dynamic Setters
  Future<void> setSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  Future<void> setPrayerTimes(String key, dynamic value) async {
    await _prayerBox.put(key, value).then((value) {
    },);
  }

  // Remove a setting
  Future<void> removeSetting(String key) async {
    await _settingsBox.delete(key);
  }

  // Remove user data
  Future<void> removePrayers(String key) async {
    await _prayerBox.delete(key);
  }
}
