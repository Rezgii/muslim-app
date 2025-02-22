import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/utils/func/functions.dart';
import 'package:muslim/src/core/utils/func/local_notification_service.dart';
import 'package:muslim/src/data/models/prayer_time_model.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  late PrayerTimeModel todayPrayer;
  List<PrayerTimeModel>? daysPrayers;
  late String prayerName;
  late String prayerTime;

  RxString countdown = '- 00 : 00 : 00'.obs;
  Timer? _timer;
  bool _isPositiveTimer = false;
  bool isTestMode = false;

  @override
  void onInit() async {
    super.onInit();
    daysPrayers = Get.arguments['prayersTime'];
    todayPrayer = daysPrayers![0];
    _updateNextPrayer();
    _initializeAndStartCountdown();
    _formatPrayerTime();
  }

  @override
  void onReady() async {
    super.onReady();
    await requestNotificationPermission().then((value) {
      scheduleWeekPrayers();

      //TODO: Foreground Service

      // ForeGroundService.instance
      //     .startService();
    });
    await FirebaseMessaging.instance.subscribeToTopic("updates");

    _checkForUpdates();
  }

  String convertTimeFormat(String inputTime) {
    // // Remove spaces around the colon
    String cleanedTime = inputTime.replaceAll(' ', '');

    // Parse the input string as a DateTime object
    final parsedTime = DateTime.parse('1970-01-01 $cleanedTime');

    // Format the time using the intl package
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
        log(error.message);
      }
    }
  }

  void _formatPrayerTime() {
    prayerTime =
        '${prayerTime.substring(0, 2)} ${prayerTime.substring(2, 3)} ${prayerTime.substring(3)}';
  }

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
