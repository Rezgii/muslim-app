// import 'dart:async';
// import 'dart:developer';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:muslim/src/core/config/hive_service.dart';
// import 'package:muslim/src/core/utils/func/foreground_Service.dart';
// import 'package:muslim/src/core/utils/func/functions.dart';
// import 'package:muslim/src/core/utils/func/local_notification_service.dart';
// import 'package:muslim/src/data/models/prayer_time_model.dart';
// // ignore: depend_on_referenced_packages
// import 'package:intl/intl.dart';

// class SalatTaskHandler extends TaskHandler {
//   SalatTaskHandler._();
//   static final instance = SalatTaskHandler._();

//   bool isSoundPlaying = false;
//   String prayerName = '';
//   String prayerTime = '';
//   Map<dynamic, dynamic>? yearPrayers;
//   String countdown = '- 00 : 00 : 00';
//   Timer? _timer;
//   bool _isPositiveTimer = false;
//   late AudioPlayer player;
//   Map<String, String> arabicPrayerNames = {
//     'Imsak': 'الإمساك',
//     'Fajr': 'الفجر',
//     'Sunrise': 'الشروق',
//     'Dhuhr': 'الظهر',
//     'Asr': 'العصر',
//     'Maghrib': 'المغرب',
//     'Isha': 'العشاء',
//     'Last Third': 'الثلث الأخير',
//   };

//   /// Initializes  Hive, Get Data, and Open Listening.
//   void _listenToPrayer() async {
//     log('Listen To Prayer');
//     // log(' ${}');
//     try {
//       await HiveService.instance.init();

//       yearPrayers = HiveService.instance.getPrayers();

//       if (yearPrayers == null) {
//         log('No prayer data found.');
//         return;
//       }

//       _getNextPrayer(yearPrayers!, false);
//     } on FirebaseException catch (e, st) {
//       log('Firebase error: ${e.message} \n $st');
//     } catch (e, st) {
//       log('General error: $e \n $st');
//     }
//   }

//   void _initializeAndStartCountdown() {
//     DateTime nextPrayerDateTime = _parsePrayerTime(prayerTime);

//     if (nextPrayerDateTime.isBefore(DateTime.now())) {
//       Duration passedDuration = DateTime.now().difference(nextPrayerDateTime);

//       if (passedDuration.inMinutes < 30) {
//         countdown = _formatPositiveDuration(passedDuration);
//         _isPositiveTimer = true;
//       } else {
//         nextPrayerDateTime = nextPrayerDateTime.add(const Duration(days: 1));
//         countdown =
//             _formatDuration(nextPrayerDateTime.difference(DateTime.now()));
//         _isPositiveTimer = false;
//       }
//     } else {
//       countdown =
//           _formatDuration(nextPrayerDateTime.difference(DateTime.now()));
//       _isPositiveTimer = false;
//     }

//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (_isPositiveTimer) {
//         _startCountUpTimer(nextPrayerDateTime);
//       } else {
//         _startCountDownTimer(nextPrayerDateTime);
//       }
//     });
//   }

//   void _startCountDownTimer(DateTime nextPrayerDateTime) {
//     Duration remaining = nextPrayerDateTime.difference(DateTime.now());
//     if (remaining.inSeconds >= 0) {
//       countdown = _formatDuration(remaining);
//       FlutterForegroundTask.updateService(
//         notificationTitle: arabicPrayerNames[prayerName],
//         notificationText: '${_convertTimeFormat(prayerTime)} | $countdown',
//         notificationButtons: [
//           const NotificationButton(
//             id: 'btn_stop',
//             text: 'إغلاق الإشعار',
//             textColor: Colors.red,
//           ),
//         ],
//       );
//       if (remaining.inSeconds == 0) {
//         if (!isSoundPlaying) {
//           isSoundPlaying = true;

//           player.play(AssetSource('sounds/adhan.mp3')).then((_) {
//             LocalNotificationService.adhanNotification(
//                 adhanName:
//                     'حان الآن موعد آذان ${arabicPrayerNames[prayerName]}',
//                 adhanTime: _convertTimeFormat(prayerTime));
//           }).catchError((error) {
//             log('Error playing sound: $error');
//             isSoundPlaying = false;
//           });
//         }
//         _isPositiveTimer = true;
//         _timer?.cancel();
//         _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//           _startCountUpTimer(nextPrayerDateTime);
//         });
//       }
//     } else {
//       _isPositiveTimer = true;
//       _timer?.cancel();
//       _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//         _startCountUpTimer(nextPrayerDateTime);
//       });
//     }
//   }

//   void _startCountUpTimer(DateTime initialPrayerEndTime) {
//     Duration positiveRemaining =
//         DateTime.now().difference(initialPrayerEndTime);
//     if (positiveRemaining.inMinutes < 30) {
//       countdown = _formatPositiveDuration(positiveRemaining);
//       FlutterForegroundTask.updateService(
//         notificationTitle: arabicPrayerNames[prayerName],
//         notificationText: '${_convertTimeFormat(prayerTime)} | $countdown',
//         notificationButtons: [
//           const NotificationButton(
//             id: 'btn_stop',
//             text: 'إغلاق الإشعار',
//             textColor: Colors.red,
//           ),
//         ],
//       );
//     } else {
//       _isPositiveTimer = false;
//       _getNextPrayer(yearPrayers!, false);
//       _initializeAndStartCountdown();
//     }
//   }

//   String _formatDuration(Duration duration) {
//     String hours = duration.inHours.remainder(24).toString().padLeft(2, '0');
//     String minutes =
//         duration.inMinutes.remainder(60).toString().padLeft(2, '0');
//     String seconds =
//         duration.inSeconds.remainder(60).toString().padLeft(2, '0');
//     return "- $hours : $minutes : $seconds";
//   }

//   String _formatPositiveDuration(Duration duration) {
//     String minutes =
//         duration.inMinutes.remainder(60).toString().padLeft(2, '0');
//     String seconds =
//         duration.inSeconds.remainder(60).toString().padLeft(2, '0');
//     return "+ 00 : $minutes : $seconds";
//   }

//   String _convertTimeFormat(String inputTime) {
//     final parsedTime = DateTime.parse('1970-01-01 $inputTime');
//     final formattedTime = DateFormat('hh:mm a').format(parsedTime);

//     return formattedTime;
//   }

//   void _getNextPrayer(Map<dynamic, dynamic> yearPrayers, bool testMode) {
//     DateTime now = DateTime.now();
//     DateTime? nextPrayerDateTime;
//     String? nextPrayerName;

//     if (!testMode) {
//       now.add(const Duration(days: 1));
//       List<PrayerTimeModel> daysPrayers = [
//         PrayerTimeModel.fromMap(yearPrayers[now.month.toString()][now.day - 1])
//       ];
//       now.subtract(const Duration(days: 1));
//       daysPrayers.add(PrayerTimeModel.fromMap(
//           yearPrayers[now.month.toString()][now.day - 1]));

//       PrayerTimeModel todayPrayer = daysPrayers[0];

//       todayPrayer.prayersTime.forEach((name, time) {
//         DateTime prayerDateTime = _parsePrayerTime(time);
//         if (prayerDateTime.isBefore(now) &&
//             name != 'Sunset' &&
//             name != 'Imsak' &&
//             name != 'Firstthird' &&
//             name != 'Lastthird' &&
//             name != 'Midnight') {
//         } else if (prayerDateTime.isAfter(now) &&
//             name != 'Sunset' &&
//             name != 'Imsak' &&
//             name != 'Firstthird' &&
//             name != 'Lastthird' &&
//             name != 'Midnight') {
//           if (nextPrayerDateTime == null ||
//               prayerDateTime.isBefore(nextPrayerDateTime!)) {
//             nextPrayerDateTime = prayerDateTime;
//             nextPrayerName = name;
//             return;
//           }
//         }
//       });

//       if (nextPrayerDateTime == null) {
//         todayPrayer = daysPrayers[1];
//         nextPrayerName = todayPrayer.prayersTime.keys.first;
//         nextPrayerDateTime =
//             _parsePrayerTime(todayPrayer.prayersTime[nextPrayerName]!);
//       }

//       if (nextPrayerName != null && nextPrayerDateTime != null) {
//         prayerName = nextPrayerName!;
//         prayerTime = _formatTime(nextPrayerDateTime!);
//       }
//     } else {
//       prayerName = "MOGHRIIIIIB";
//       prayerTime = _formatTime(_parsePrayerTime("12:33"));
//     }

//     _initializeAndStartCountdown();
//   }

//   String _formatTime(DateTime dateTime) {
//     return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
//   }

//   DateTime _parsePrayerTime(String time) {
//     int hour = int.parse(time.substring(0, 2));
//     int minute = int.parse(time.substring(3, 5));
//     return DateTime(
//         prayerDay.year, prayerDay.month, prayerDay.day, hour, minute);
//   }

//   Future<void> playAdhan() async {
//     return player.play(AssetSource('sounds/adhan.mp3'));
//   }

//   Future<void> stopAdhan() async {
//     return player.stop();
//   }

//   @override
//   Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
//     player = AudioPlayer();
//     _listenToPrayer();
//   }

//   @override
//   Future<void> onDestroy(DateTime timestamp) async {
//     log('=> Foreground service stopped');
//     await player.dispose();
//   }

//   @override
//   void onReceiveData(Object data) {
//     log('=> Data received: $data');
//     if (data == 'Stop') {
//       player.stop();
//     }
//   }

//   @override
//   void onNotificationButtonPressed(String id) {
//     if (id == 'btn_stop_sound') {
//       log('=> Stop sound button pressed');
//       player.stop().then(
//         (value) {
//           log('=> Sound stopped successfuly');
//           isSoundPlaying = false;
//           FlutterForegroundTask.updateService(
//             notificationTitle: arabicPrayerNames[prayerName],
//             notificationText: '${_convertTimeFormat(prayerTime)} | $countdown',
//             notificationButtons: [
//               const NotificationButton(
//                 id: 'btn_stop',
//                 text: 'إغلاق الإشعار',
//                 textColor: Colors.red,
//               ),
//             ],
//           );
//         },
//       );
//     }

//     if (id == 'btn_stop') {
//       ForeGroundService.instance.stopService();
//     }

//     if (id == 'btn_open_app') {
//       log('=> Open app button pressed');
//     }
//   }

//   @override
//   void onNotificationPressed() {
//     player.stop();
//     isSoundPlaying = false;
//     log('=> Notification pressed');
//   }

//   @override
//   void onNotificationDismissed() {
//     log('=> Notification dismissed');
//     player.stop();
//     isSoundPlaying = false;
//     FlutterForegroundTask.updateService(
//       notificationTitle: arabicPrayerNames[prayerName],
//       notificationText: '${_convertTimeFormat(prayerTime)} | $countdown',
//       notificationButtons: [
//         const NotificationButton(
//           id: 'btn_stop',
//           text: 'إغلاق الإشعار',
//           textColor: Colors.red,
//         ),
//       ],
//     );
//   }

//   @override
//   void onRepeatEvent(DateTime timestamp) {
//     log('=> Repeat event');
//   }
// }
