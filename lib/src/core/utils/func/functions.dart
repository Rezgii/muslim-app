import 'dart:developer';
import 'dart:isolate';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/config/hive_service.dart';
import 'package:muslim/src/core/utils/func/local_notification_service.dart';
import 'package:muslim/src/data/apis/current_date_api.dart';
import 'package:muslim/src/data/apis/prayer_time_api.dart';
import 'package:muslim/src/data/apis/prayer_time_calendar_api.dart';
import 'package:muslim/src/data/models/prayer_time_model.dart';
import 'package:muslim/src/presentation/screens/home_screen.dart';
import 'package:muslim/src/presentation/screens/location_permission_screen.dart';
import 'package:permission_handler/permission_handler.dart';

bool get isLocationGiven =>
    HiveService.instance.getSetting('location') ?? false;
Map<dynamic, dynamic> location =
    HiveService.instance.getSetting('locationData');
bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;
List<PrayerTimeModel>? prayersTime;

late String prayerName;
late String prayerTime;
DateTime prayerDay = DateTime.now();

void initializeScreen() async {
  if (isLocationGiven) {
    if (HiveService.instance.getPrayerTimes('yearlyPrayerTime') == null &&
        HiveService.instance.getPrayerTimes('year') != DateTime.now().year) {
      prayersTime = await getDataFromAPI();

      //ISOLATE HERE
      ReceivePort receivePort = ReceivePort();
      Isolate.spawn(isolateTask,
          [receivePort.sendPort, location['latitude'], location['longitude']]);

      receivePort.listen((message) {
        log("Isolate Listen");
        _savePrayersInHive(message);
        receivePort.close();
      });

      // (wait) Receive the result (data to save in hive)
      // Map<String, dynamic> resultData = await receivePort.first;
      // _savePrayersInHive(resultData);
    } else {
      prayersTime = getDataFromHive();
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

void isolateTask(List<dynamic> args) async {
  log("Start Isolate Func");
  SendPort sendPort = args[0];
  String latitude = args[1];
  String longitude = args[2];
  Map<String, dynamic> yearlyPrayerTime = await PrayerTimeCalendarApi.instance
      .getPrayerTimeCalendar(
          latitude, longitude, DateTime.now().year.toString());
  sendPort.send(yearlyPrayerTime);
  log("End Isolate Func");
}

void requestNotificationPermission() async {
  final status = await Permission.notification.request();

  if (status.isGranted) {
  } else if (status.isDenied) {
    await Permission.notification.request();
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
  }
}

Future<void> scheduleWeekPrayers() async {
  log('========START Scheduling=======');
  // bool testMode = false;
  DateTime now = DateTime.now();

// Determine the week's range (start from today to the next 7 days).
  List<DateTime> weekDays = List.generate(
    7,
    (index) => now.add(Duration(days: index)),
  );
  log("========Prayers========");

  for (DateTime day in weekDays) {
    PrayerTimeModel dayPrayers = PrayerTimeModel.fromMap(HiveService.instance
        .getPrayerTimes('yearlyPrayerTime')[day.month.toString()][day.day - 1]);
    dayPrayers.prayersTime.forEach((name, time) {
      DateTime prayerDateTime = _parsePrayerTime(time, day);
      if (prayerDateTime.isAfter(now) &&
          name != 'Sunset' &&
          name != 'Imsak' &&
          name != 'Sunrise' &&
          name != 'Firstthird' &&
          name != 'Lastthird' &&
          name != 'Midnight') {
        // Schedule the prayer (e.g., notifications).
        LocalNotificationService.scheduledNotification(
            title: name.tr,
            body: formatDateTimeToTimeString(prayerDateTime),
            time: prayerDateTime);
      }
    });
  }
  log('========END Scheduling=======');
}

DateTime _parsePrayerTime(String time, DateTime date) {
  int hour = int.parse(time.substring(0, 2));
  int minute = int.parse(time.substring(3, 5));
  return DateTime(date.year, date.month, date.day, hour, minute);
}

String formatDateTimeToTimeString(DateTime dateTime) {
  int hour = dateTime.hour;
  int minute = dateTime.minute;
  String period = hour >= 12 ? "PM" : "AM";

  // Convert 24-hour time to 12-hour time
  hour = hour % 12 == 0 ? 12 : hour % 12;

  // Format the time string
  return "${hour.toString().padLeft(2, '0')} : ${minute.toString().padLeft(2, '0')} $period";
}

Future<void> _savePrayersInHive(Map<String, dynamic> yearlyPrayerTime) async {
  log('========START Saving=======');

  await HiveService.instance.setPrayerTimes(
    'yearlyPrayerTime',
    yearlyPrayerTime,
  );
  await HiveService.instance.setPrayerTimes(
    'year',
    DateTime.now().year,
  );
  scheduleWeekPrayers();

  log('========END Saving=======');
}

Future<List<PrayerTimeModel>> getDataFromAPI() async {
  List<PrayerTimeModel> daysPrayers = [];
  String date = await CurrentDateApi.instance.getDate('Africa/Algiers');
  daysPrayers.add(PrayerTimeModel.fromMap(await PrayerTimeApi.instance
      .getPrayerTime(location['latitude'], location['longitude'], date)));
  date = addOneDayToDate(date);
  daysPrayers.add(PrayerTimeModel.fromMap(await PrayerTimeApi.instance
      .getPrayerTime(location['latitude'], location['longitude'], date)));

  return daysPrayers;
}

String addOneDayToDate(String dateString) {
  // Split the input date string into day, month, and year
  List<String> parts = dateString.split('-');
  int day = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int year = int.parse(parts[2]);

  // Create a DateTime object from the parsed values
  DateTime date = DateTime(year, month, day);

  // Add one day
  DateTime newDate = date.add(const Duration(days: 1));

  // Return the new date in the same format "DD-MM-YYYY"
  return "${newDate.day.toString().padLeft(2, '0')}-${newDate.month.toString().padLeft(2, '0')}-${newDate.year}";
}

List<PrayerTimeModel> getDataFromHive() {
  List<PrayerTimeModel> daysPrayers = [];
  DateTime today = DateTime.now();
  daysPrayers.add(PrayerTimeModel.fromMap(HiveService.instance
          .getPrayerTimes('yearlyPrayerTime')[today.month.toString()]
      [today.day - 1]));
  today = today.add(const Duration(days: 1));
  daysPrayers.add(PrayerTimeModel.fromMap(HiveService.instance
          .getPrayerTimes('yearlyPrayerTime')[today.month.toString()]
      [today.day - 1]));
  return daysPrayers;
}

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
