import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/user_model.dart';



class HiveService {
  HiveService._();
  static HiveService instance = HiveService._();
  late Box _settingsBox;
  late Box _userBox;

  Future<void> init() async {
    try {
      await Hive.initFlutter();
      Hive.registerAdapter(UserModelAdapter());
      _settingsBox = await Hive.openBox('settings');
      _userBox = await Hive.openBox('user');

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
  Box get userBox => _userBox;

  // Dynamic Getters
  dynamic getSetting(String key) => _settingsBox.get(key);
  dynamic getUserData(String key) => _userBox.get(key);

  // Dynamic Setters
  Future<void> setSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  Future<void> setUserData(String key, dynamic value) async {
    await _userBox.put(key, value);
  }

  // Remove a setting
  Future<void> removeSetting(String key) async {
    await _settingsBox.delete(key);
  }

  // Remove user data
  Future<void> removeUserData(String key) async {
    await _userBox.delete(key);
  }
}
