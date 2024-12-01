import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/config/hive_service.dart';
import 'package:muslim/src/data/apis/current_date_api.dart';
import 'package:muslim/src/data/apis/prayer_time_api.dart';
import 'package:muslim/src/data/apis/prayer_time_calendar_api.dart';
import 'package:muslim/src/data/models/prayer_time_model.dart';
import 'package:muslim/src/presentation/screens/home_screen.dart';
import 'package:muslim/src/presentation/screens/location_permission_screen.dart';

bool get isLocationGiven =>
    HiveService.instance.getSetting('location') ?? false;
Map<String, dynamic> location = HiveService.instance.getSetting('locationData');
bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

void initializeScreen() async {
  if (isLocationGiven) {
    if (HiveService.instance.getPrayerTimes('yearlyPrayerTime') == null) {
      await _savePrayersInHive(DateTime.now().year.toString());
    }
    PrayerTimeModel prayersTime = await getDate();
    Get.offAll(
      () => const HomeScreen(),
      arguments: {
        'prayersTime': prayersTime,
      },
      duration: const Duration(milliseconds: 650),
      transition: Transition.circularReveal,
      curve: Curves.easeIn,
    );
  } else {
    Get.offAll(
      () => const LocationPermissionScreen(),
      duration: const Duration(milliseconds: 650),
      transition: Transition.circularReveal,
      curve: Curves.easeIn,
    );
  }
}

Future<void> _savePrayersInHive(String year) async {
  Map<String, dynamic> yearlyPrayerTime = await PrayerTimeCalendarApi.instance
      .getPrayerTimeCalendar(location['latitude'], location['longitude'], year);
  await HiveService.instance.setPrayerTimes(
    'yearlyPrayerTime',
    yearlyPrayerTime,
  );
}

Future<PrayerTimeModel> getDate() async {
  if (HiveService.instance.getPrayerTimes('yearlyPrayerTime') == null) {
    String date = await CurrentDateApi.instance.getDate('Africa/Algiers');
    return PrayerTimeModel.fromMap(await PrayerTimeApi.instance
        .getPrayerTime(location['latitude'], location['longitude'], date));
  } else {
    DateTime today = DateTime.now();
    return PrayerTimeModel.fromMap(HiveService.instance
            .getPrayerTimes('yearlyPrayerTime')[today.month.toString()]
        [today.day - 1]);
  }
}
