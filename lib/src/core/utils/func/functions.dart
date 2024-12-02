import 'package:audioplayers/audioplayers.dart';
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
PrayerTimeModel? prayersTime;

late String prayerName;
late String prayerTime;
DateTime prayerDay = DateTime.now();

void initializeScreen() async {
  if (isLocationGiven) {
    prayersTime = await getDataFromAPI();
    // setupPrayerDay();

    if (HiveService.instance.getPrayerTimes('yearlyPrayerTime') == null) {
      await _savePrayersInHive(DateTime.now().year.toString());
    }
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

Future<PrayerTimeModel> getDataFromAPI() async {
  String date = await CurrentDateApi.instance.getDate('Africa/Algiers');
  return PrayerTimeModel.fromMap(await PrayerTimeApi.instance
      .getPrayerTime(location['latitude'], location['longitude'], date));
}

PrayerTimeModel getDataFromHive() {
  DateTime today = DateTime.now();
  return PrayerTimeModel.fromMap(HiveService.instance
          .getPrayerTimes('yearlyPrayerTime')[today.month.toString()]
      [today.day - 1]);
}

// DateTime setupPrayerDay() {
//   prayerDay = DateTime(
//     int.parse(prayersTime!.date['gregorian']['year']),
//     prayersTime!.date['gregorian']['month']['number'],
//     int.parse(prayersTime!.date['gregorian']['day']),
//   );
//   return prayerDay;
// }

// List<dynamic> updateNextPrayer(
//     {required bool isTestMode, required bool isWidget, Box? prayerBox}) {
//   DateTime now = DateTime.now();
//   DateTime? nextPrayerDateTime;
//   String? nextPrayerName;

//   if (!isTestMode) {
//     prayersTime!.prayersTime.forEach((name, time) {
//       DateTime prayerDateTime = parsePrayerTime(time);
//       if (prayerDateTime.isBefore(now) &&
//           name != 'Sunset' &&
//           name != 'Imsak' &&
//           name != 'Firstthird' &&
//           name != 'Lastthird' &&
//           name != 'Midnight') {
//         Duration passedDuration = DateTime.now().difference(prayerDateTime);
//         if (!isWidget && passedDuration.inMinutes < 30) {
//           nextPrayerDateTime = prayerDateTime;
//           nextPrayerName = name;
//         }
//       } else if (prayerDateTime.isAfter(now) &&
//           name != 'Sunset' &&
//           name != 'Imsak' &&
//           name != 'Firstthird' &&
//           name != 'Lastthird' &&
//           name != 'Midnight') {
//         if (nextPrayerDateTime == null ||
//             prayerDateTime.isBefore(nextPrayerDateTime!)) {
//           nextPrayerDateTime = prayerDateTime;
//           nextPrayerName = name;
//           return;
//         }
//       }
//     });

//     if (nextPrayerDateTime == null) {
//       now = now.add(const Duration(days: 1));
//       if (prayerBox == null) {
//         prayersTime = PrayerTimeModel.fromMap(HiveService.instance
//                 .getPrayerTimes('yearlyPrayerTime')[now.month.toString()]
//             [now.day - 1]);
//       } else {
//         prayersTime = PrayerTimeModel.fromMap(prayerBox
//             .get('yearlyPrayerTime')[now.month.toString()][now.day - 1]);
//       }
//       nextPrayerName = prayersTime!.prayersTime.keys.first;
//       nextPrayerDateTime =
//           parsePrayerTime(prayersTime!.prayersTime[nextPrayerName]!);
//     }

//     if (nextPrayerName != null && nextPrayerDateTime != null) {
//       prayerName = nextPrayerName!;
//       prayerTime = _formatTime(nextPrayerDateTime!);
//     }
//   } else {
//     prayerName = "DHohr";
//     prayerTime = _formatTime(parsePrayerTime("17:02"));
//   }
//   return [prayerName, prayerTime];
// }

// DateTime parsePrayerTime(String time) {
//   int hour = int.parse(time.substring(0, 2));
//   int minute = int.parse(time.substring(3, 5));
//   return DateTime(prayerDay.year, prayerDay.month, prayerDay.day, hour, minute);
// }

// String _formatTime(DateTime dateTime) {
//   return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
// }

void playAdhan() async {
  final player = AudioPlayer();

  // Configure the audio context
  await player.setAudioContext(
    AudioContext(
      android: const AudioContextAndroid(
        isSpeakerphoneOn: true, // Use the speaker for output
        stayAwake: true,
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.alarm, // Forces higher priority playback
        audioFocus:
            AndroidAudioFocus.gainTransientExclusive, // Full volume override
      ),
      iOS: AudioContextIOS(
        category:
            AVAudioSessionCategory.playback, // Allows audio even in silent mode
        options: const {
          AVAudioSessionOptions.mixWithOthers,
          AVAudioSessionOptions.overrideMutedMicrophoneInterruption,
          AVAudioSessionOptions.duckOthers,
        }, // Optional: Mix with other sounds
      ),
    ),
  );
  player.play(AssetSource('sounds/adhan.mp3'));
}
