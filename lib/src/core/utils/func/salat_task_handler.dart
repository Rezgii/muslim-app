import 'dart:async';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/config/hive_service.dart';
import 'package:muslim/src/core/utils/func/forground_Service.dart';
import 'package:muslim/src/core/utils/func/functions.dart';
import 'package:muslim/src/data/models/prayer_time_model.dart';

final player = AudioPlayer();

class SalatTaskHandler extends TaskHandler {
  SalatTaskHandler._();
  static final instance = SalatTaskHandler._();

  bool isSoundPlaying = false;
  late String prayerName;
  late String prayerTime;
  final StreamController<String> streamController = StreamController<String>();

  /// Initializes  Hive, Get Data, and Open Listening.
  void _listenToPrayer() async {
    log('Listen To Prayer');
    streamController.add('test');
    try {
      await HiveService.instance.init();

      // Get prayer data
      final Map<dynamic, dynamic>? yearPrayers =
          HiveService.instance.getPrayers();

      if (yearPrayers == null) {
        log('No prayer data found.');
        return;
      }

      // Initialize the stream and start listening
      streamController.stream.listen(
        (currentTime) {
          log('Stream triggered at $currentTime');

          _getNextPrayer(yearPrayers);

          if (!isSoundPlaying) {
            isSoundPlaying = true;

            FlutterForegroundTask.updateService(
              notificationTitle: prayerName.tr,
              notificationText: prayerTime,
              notificationButtons: [
                const NotificationButton(
                  id: 'btn_stop_sound',
                  text: 'إيقاف الصوت',
                  textColor: Colors.red,
                ),
              ],
            );

            player.play(AssetSource('sounds/adhan.mp3')).then((_) {
              isSoundPlaying = false;

              FlutterForegroundTask.updateService(
                notificationTitle: prayerName.tr,
                notificationText: prayerTime,
              );
            }).catchError((error) {
              log('Error playing sound: $error');
              isSoundPlaying = false;
            });
          }
        },
        onError: (error) {
          log('Stream error: $error');
        },
      );
    } on FirebaseException catch (e, st) {
      log('Firebase error: ${e.message} \n $st');
    } catch (e, st) {
      log('General error: $e \n $st');
    }
  }

  void _getNextPrayer(Map<dynamic, dynamic> yearPrayers) {
    DateTime now = DateTime.now();
    DateTime? nextPrayerDateTime;
    String? nextPrayerName;

    now.add(const Duration(days: 1));
    List<PrayerTimeModel> daysPrayers = [
      PrayerTimeModel.fromMap(yearPrayers[now.month.toString()][now.day - 1])
    ];
    now.subtract(const Duration(days: 1));
    daysPrayers.add(PrayerTimeModel.fromMap(
        yearPrayers[now.month.toString()][now.day - 1]));

    PrayerTimeModel todayPrayer = daysPrayers[0];

    todayPrayer.prayersTime.forEach((name, time) {
      DateTime prayerDateTime = _parsePrayerTime(time);
      if (prayerDateTime.isBefore(now) &&
          name != 'Sunset' &&
          name != 'Imsak' &&
          name != 'Firstthird' &&
          name != 'Lastthird' &&
          name != 'Midnight') {
      } else if (prayerDateTime.isAfter(now) &&
          name != 'Sunset' &&
          name != 'Imsak' &&
          name != 'Firstthird' &&
          name != 'Lastthird' &&
          name != 'Midnight') {
        if (nextPrayerDateTime == null ||
            prayerDateTime.isBefore(nextPrayerDateTime!)) {
          nextPrayerDateTime = prayerDateTime;
          nextPrayerName = name;
          return;
        }
      }
    });

    if (nextPrayerDateTime == null) {
      todayPrayer = daysPrayers[1];
      nextPrayerName = todayPrayer.prayersTime.keys.first;
      nextPrayerDateTime =
          _parsePrayerTime(todayPrayer.prayersTime[nextPrayerName]!);
    }

    if (nextPrayerName != null && nextPrayerDateTime != null) {
      prayerName = nextPrayerName!;
      prayerTime = _formatTime(nextPrayerDateTime!);
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  DateTime _parsePrayerTime(String time) {
    int hour = int.parse(time.substring(0, 2));
    int minute = int.parse(time.substring(3, 5));
    return DateTime(
        prayerDay.year, prayerDay.month, prayerDay.day, hour, minute);
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _listenToPrayer();
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    log('=> Foreground service stopped');
    streamController.close();
  }

  @override
  void onReceiveData(Object data) {
    log('=> Data received: $data');
  }

//////////////////
  @override
  void onNotificationButtonPressed(String id) {
    if (id == 'btn_stop_sound') {
      log('=> Stop sound button pressed');
      player.stop();
      isSoundPlaying = false;
      FlutterForegroundTask.updateService(
        notificationTitle: prayerName.tr,
        notificationText: prayerTime,
      );
    }

    if (id == 'btn_stop') {
      ForeGroundService.instance.stopService();
    }

    if (id == 'btn_open_app') {
      log('=> Open app button pressed');
    }
  }
  //////////

  @override
  void onNotificationPressed() {
    player.stop();
    isSoundPlaying = false;
    log('=> Notification pressed');
  }

  @override
  void onNotificationDismissed() {
    log('=> Notification dismissed');
    player.stop();
    isSoundPlaying = false;
    FlutterForegroundTask.updateService(
      notificationTitle: prayerName.tr,
      notificationText: prayerTime,
      notificationButtons: [
        const NotificationButton(
            id: 'btn_stop_sound', text: 'إيقاف الصوت', textColor: Colors.red),
      ],
    );
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    log('=> Repeat event');
  }
}
