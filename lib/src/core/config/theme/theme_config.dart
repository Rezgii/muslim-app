import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/const/app_colors.dart';

var baseTheme = ThemeData(brightness: Brightness.dark);

class ThemeConfig {
  static ThemeData darkTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: AppColors.seedColor,
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      surface: AppColors.backgroundColor,
      surfaceTint: Colors.transparent,
    ),
    useMaterial3: true,
    textTheme: GoogleFonts.lexendTextTheme(baseTheme.textTheme),
  );
}
