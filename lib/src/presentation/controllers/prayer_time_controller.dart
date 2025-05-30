import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:muslim/src/core/config/hive_service.dart';
import 'package:muslim/src/data/models/prayer_time_model.dart';

class PrayerTimeController extends GetxController {
  PrayerTimeModel todayPrayer = Get.arguments['prayersTime'];
  final bool isToday = Get.arguments['isToday'];
  late String prayerName = '';
  late String prayerTime = '';
  late DateTime prayerDay;
  late String date = '';
  late String dateHijri = '';
  late String day = '';

  RxString countdown = '- 00 : 00 : 00'.obs;
  Timer? _timer;
  bool _isPositiveTimer = false;

  // Get next prayer time and setup the counter
  @override
  void onInit() {
    super.onInit();

    _setupPrayerDay();
    if (isToday) {
      _updateNextPrayer();
      _initializeAndStartCountdown();
    }
    _formatFields();
  }

  // Converting The Prayer Day to DateTime
  void _setupPrayerDay() {
    prayerDay = DateTime(
      int.parse(todayPrayer.date['gregorian']['year']),
      todayPrayer.date['gregorian']['month']['number'],
      int.parse(todayPrayer.date['gregorian']['day']),
    );
  }

  // Checking the prayer time to setup the time line
  bool isPrayerBefore(String name) {
    DateTime prayerDateTime = _parsePrayerTime(todayPrayer.prayersTime[name]);
    if (prayerDateTime.isBefore(DateTime.now())) {
      return true;
    } else {
      return false;
    }
  }

  // Date translation (from api)
  void _formatFields() {
    if (Get.locale == const Locale('ar_AE')) {
      date =
          "${todayPrayer.date['gregorian']['day']} ${todayPrayer.date['gregorian']['month']['en']} ${todayPrayer.date['gregorian']['year']}";

      dateHijri =
          "${todayPrayer.date['hijri']['day']} ${todayPrayer.date['hijri']['month']['en']} ${todayPrayer.date['hijri']['year']}";

      day = todayPrayer.date['gregorian']['weekday']['en'];
    } else {
      date =
          "${todayPrayer.date['gregorian']['day']} ${todayPrayer.date['gregorian']['month']['en'].toString().tr} ${todayPrayer.date['gregorian']['year']}";
      dateHijri =
          "${todayPrayer.date['hijri']['day']} ${todayPrayer.date['hijri']['month']['ar']} ${todayPrayer.date['hijri']['year']}";

      day = todayPrayer.date['hijri']['weekday']['ar'];
    }
    if (isToday) {
      prayerTime =
          '${prayerTime.substring(0, 2)} ${prayerTime.substring(2, 3)} ${prayerTime.substring(3)}';
    }
  }

  // Convert Prayer Time to DateTime for Counter
  DateTime _parsePrayerTime(String time) {
    int hour = int.parse(time.substring(0, 2));
    int minute = int.parse(time.substring(3, 5));
    return DateTime(
      prayerDay.year,
      prayerDay.month,
      prayerDay.day,
      hour,
      minute,
    );
  }

  void _initializeAndStartCountdown() {
    DateTime nextPrayerDateTime = _parsePrayerTime(prayerTime);

    if (nextPrayerDateTime.isBefore(DateTime.now())) {
      Duration passedDuration = DateTime.now().difference(nextPrayerDateTime);

      if (passedDuration.inMinutes < 30) {
        countdown.value = _formatPositiveDuration(passedDuration);
        _isPositiveTimer = true;
      } else {
        nextPrayerDateTime = nextPrayerDateTime.add(const Duration(days: 1));
        countdown.value = _formatDuration(
          nextPrayerDateTime.difference(DateTime.now()),
        );
        _isPositiveTimer = false;
      }
    } else {
      countdown.value = _formatDuration(
        nextPrayerDateTime.difference(DateTime.now()),
      );
      _isPositiveTimer = false;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isPositiveTimer) {
        _startCountUpTimer(nextPrayerDateTime);
      } else {
        _startCountDownTimer(nextPrayerDateTime);
      }
    });
  }

  void _startCountDownTimer(DateTime nextPrayerDateTime) {
    Duration remaining = nextPrayerDateTime.difference(DateTime.now());
    if (remaining.inSeconds > 0) {
      countdown.value = _formatDuration(remaining);
    } else {
      _isPositiveTimer = true;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _startCountUpTimer(nextPrayerDateTime);
      });
    }
  }

  void _startCountUpTimer(DateTime initialPrayerEndTime) {
    Duration positiveRemaining = DateTime.now().difference(
      initialPrayerEndTime,
    );
    if (positiveRemaining.inMinutes < 30) {
      countdown.value = _formatPositiveDuration(positiveRemaining);
    } else {
      _isPositiveTimer = false;
      _updateNextPrayer();
      _initializeAndStartCountdown();
    }
  }

  // To Display Remaining Time (ex: "- 00 : 43 : 12")
  String _formatDuration(Duration duration) {
    String hours = duration.inHours.remainder(24).toString().padLeft(2, '0');
    String minutes = duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    String seconds = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return "- $hours : $minutes : $seconds";
  }

  // To Display Passed Time (ex: "+ 00 : 10 : 15")
  String _formatPositiveDuration(Duration duration) {
    String minutes = duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    String seconds = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return "+ 00 : $minutes : $seconds";
  }

  void _updateNextPrayer() {
    DateTime now = DateTime.now();
    DateTime? nextPrayerDateTime;
    String? nextPrayerName;

    todayPrayer.prayersTime.forEach((name, time) {
      DateTime prayerDateTime = _parsePrayerTime(time);
      if (prayerDateTime.isBefore(now) &&
          name != 'Sunset' &&
          name != 'Firstthird' &&
          name != 'Midnight') {
        Duration passedDuration = DateTime.now().difference(prayerDateTime);
        if (passedDuration.inMinutes < 30) {
          nextPrayerDateTime = prayerDateTime;
          nextPrayerName = name;
        }
      } else if (prayerDateTime.isAfter(now) &&
          name != 'Sunset' &&
          name != 'Firstthird' &&
          name != 'Midnight') {
        if (nextPrayerDateTime == null ||
            prayerDateTime.isBefore(nextPrayerDateTime!)) {
          nextPrayerDateTime = prayerDateTime;
          nextPrayerName = name;
        }
      }
    });

    if (nextPrayerDateTime == null) {
      now = now.add(const Duration(days: 1));
      todayPrayer = PrayerTimeModel.fromMap(
        HiveService.instance.getPrayerTimes('yearlyPrayerTime')[now.month
            .toString()][now.day - 1],
      );
      nextPrayerName = todayPrayer.prayersTime.keys.first;
      nextPrayerDateTime = _parsePrayerTime(
        todayPrayer.prayersTime[nextPrayerName]!,
      );
    }

    if (nextPrayerName != null && nextPrayerDateTime != null) {
      prayerName = nextPrayerName!;
      prayerTime = _formatTime(nextPrayerDateTime!);
    }
    update();
  }

  // Format Time (ex: from "12 : 28" to "12:28")
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Format Time with AM or PM (ex: from "12:28 (CET)" to "12:28 PM")
  String convertTimeFormat(String inputTime) {
    String cleanedTime;

    if (inputTime.contains('CET')) {
      cleanedTime = inputTime.split(' ')[0];
    } else {
      cleanedTime = inputTime.replaceAll(' ', '');
    }

    final parsedTime = DateTime.parse('1970-01-01 $cleanedTime');

    final formattedTime = DateFormat('hh:mm a').format(parsedTime);

    return formattedTime;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
