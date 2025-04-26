import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/config/hive_service.dart';
import 'package:muslim/src/core/utils/const/quran.dart';
import 'package:muslim/src/core/utils/func/functions.dart';
import 'package:muslim/src/core/utils/func/local_notification_service.dart';
import 'package:muslim/src/data/models/prayer_time_model.dart';
import 'package:muslim/src/data/models/surah_model.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  late PrayerTimeModel todayPrayer;
  List<PrayerTimeModel>? daysPrayers;
  late String prayerName;
  late String prayerTime;
  SurahModel? surah;
  int? ayaNumber;

  RxString countdown = '- 00 : 00 : 00'.obs;
  Timer? _timer;
  bool _isPositiveTimer = false;
  bool isTestMode = false;

  // Get Next Prayer Time and Setup Counter
  @override
  void onInit() async {
    super.onInit();
    daysPrayers = Get.arguments['prayersTime'];
    todayPrayer = daysPrayers![0];
    _updateNextPrayer();
    _initializeAndStartCountdown();
    _formatPrayerTime();
    ayaOfTheDay();
  }

  //Initialize Aya of The Day
  void ayaOfTheDay() {
  final HiveService hive = HiveService.instance;
  final DateTime today = DateTime.now();

  final int? previousSurahNumber = hive.getSetting('surahNumber');
  final int? previousAyaNumber = hive.getSetting('ayaNumber');
  final DateTime? savedDate = hive.getSetting('date');

  final bool isNewDay = savedDate == null ||
      savedDate.year != today.year ||
      savedDate.month != today.month ||
      savedDate.day != today.day;

  if (isNewDay || previousSurahNumber == null || previousAyaNumber == null) {
    int surahNumber = Random().nextInt(114) + 1;
    surah = SurahModel.fromMap(quran[surahNumber - 1]);
    ayaNumber = Random().nextInt(surah!.versesCount) + 1;

    hive.setSetting('surahNumber', surahNumber);
    hive.setSetting('ayaNumber', ayaNumber);
    hive.setSetting('date', today);
  } else {
    surah = SurahModel.fromMap(quran[previousSurahNumber - 1]);
    ayaNumber = previousAyaNumber;
  }
}


  // Notification + Shorebird Updates Check
  @override
  void onReady() async {
    super.onReady();
    await requestNotificationPermission().then((value) {
      scheduleWeekPrayers();
    });
    await FirebaseMessaging.instance.subscribeToTopic("updates");

    _checkForUpdates();
  }

  //Format Time (ex: from "12 : 28" to "12:28 PM")
  String convertTimeFormat(String inputTime) {
    String cleanedTime = inputTime.replaceAll(' ', '');

    final parsedTime = DateTime.parse('1970-01-01 $cleanedTime');

    final formattedTime = DateFormat('hh:mm a').format(parsedTime);

    return formattedTime;
  }

  Future<void> _checkForUpdates() async {
    final updater = ShorebirdUpdater();
    // Check whether a new update is available.
    final status = await updater.checkForUpdate();

    if (status == UpdateStatus.outdated) {
      try {
        // Perform the update
        await updater.update();
      } on UpdateException catch (error) {
        dev.log(error.message);
      }
    }
  }

  // Format Time (ex: from "12:28" to "12:28 PM")
  void _formatPrayerTime() {
    prayerTime =
        '${prayerTime.substring(0, 2)} ${prayerTime.substring(2, 3)} ${prayerTime.substring(3)}';
  }

  // Format Prayer Time to DateTime for Counter
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
    if (remaining.inSeconds >= 0) {
      countdown.value = _formatDuration(remaining);
      if (remaining.inSeconds == 0) {
        playAdhan();
        _isPositiveTimer = true;
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          _startCountUpTimer(nextPrayerDateTime);
        });
      }
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

  void _updateNextPrayer() async {
    DateTime now = DateTime.now();
    DateTime? nextPrayerDateTime;
    String? nextPrayerName;

    if (!isTestMode) {
      todayPrayer.prayersTime.forEach((name, time) {
        DateTime prayerDateTime = _parsePrayerTime(time);
        if (prayerDateTime.isBefore(now) &&
            name != 'Sunset' &&
            name != 'Imsak' &&
            name != 'Firstthird' &&
            name != 'Lastthird' &&
            name != 'Midnight') {
          Duration passedDuration = DateTime.now().difference(prayerDateTime);
          if (passedDuration.inMinutes < 30) {
            nextPrayerDateTime = prayerDateTime;
            nextPrayerName = name;
          }
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
        todayPrayer = daysPrayers![1];
        nextPrayerName = todayPrayer.prayersTime.keys.first;
        nextPrayerDateTime = _parsePrayerTime(
          todayPrayer.prayersTime[nextPrayerName]!,
        );
      }

      if (nextPrayerName != null && nextPrayerDateTime != null) {
        prayerName = nextPrayerName!;
        prayerTime = _formatTime(nextPrayerDateTime!);
      }
    } else {
      prayerName = "testing";
      prayerTime = _formatTime(_parsePrayerTime("16:37"));
    }
    update();
  }

  // Format Time (ex: from "12 : 28" to "12:28")
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    LocalNotificationService.streamController.close();
    _timer?.cancel();
    super.onClose();
  }
}
