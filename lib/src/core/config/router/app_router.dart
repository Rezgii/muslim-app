import 'package:flutter/material.dart';
import 'package:muslim/src/presentation/screens/home_screen.dart';
import 'package:muslim/src/presentation/screens/services/prayer_time_screen.dart';
import 'package:muslim/src/presentation/screens/services/quran_screen.dart';
import 'package:muslim/src/presentation/screens/services/thiker_screen.dart';
import 'package:muslim/src/presentation/screens/splash_screen.dart';

class AppRouter {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => const SplashScreen(),
    '/home': (context) => const HomeScreen(),
    '/quran': (context) => const QuranScreen(),
    '/thiker': (context) => const ThikerScreen(),
    '/prayer': (context) => const PrayerTimeScreen(),
  };
}
