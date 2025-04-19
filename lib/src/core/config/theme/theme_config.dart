import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim/src/core/config/hive_service.dart';

import 'app_colors.dart';

class ThemeController extends GetxController {
  final Rx<ThemeMode?> _themeMode = Rx<ThemeMode?>(null);

  ThemeMode get themeMode => _themeMode.value ?? ThemeMode.system;

  @override
  void onInit() {
    super.onInit();
    initTheme();
  }

  void initTheme() {
    bool? isDarkMode = HiveService.instance.getSetting('darkMode');

    if (isDarkMode == null) {
      bool systemDark = Get.isPlatformDarkMode;
      _themeMode.value = systemDark ? ThemeMode.dark : ThemeMode.light;
      HiveService.instance.setSetting('darkMode', systemDark);
    } else {
      _themeMode.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }
  }

  // to change theme use this line => Get.find<ThemeController>().toggleTheme()
  void toggleTheme() {
    bool isDark = _themeMode.value == ThemeMode.dark;
    bool newMode = !isDark;

    _themeMode.value = newMode ? ThemeMode.dark : ThemeMode.light;
    HiveService.instance.setSetting('darkMode', newMode);
    Get.changeThemeMode(_themeMode.value!);
  }

  ThemeData get lightTheme {
    final base = ThemeData(brightness: Brightness.light);
    return ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: AppColors.seedColor,
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        surface: Colors.white,
        surfaceTint: Colors.transparent,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.lexendTextTheme(base.textTheme),
    );
  }

  ThemeData get darkTheme {
    final base = ThemeData(brightness: Brightness.dark);
    return ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: AppColors.seedColor,
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        surface: AppColors.backgroundColor,
        surfaceTint: Colors.transparent,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.lexendTextTheme(base.textTheme),
    );
  }
}
