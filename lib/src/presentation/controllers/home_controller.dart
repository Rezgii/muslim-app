import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/config/hive_service.dart';
import 'package:muslim/src/data/apis/prayer_time_calendar_by_address_api.dart';
import 'package:muslim/src/data/models/prayer_time_model.dart';

class HomeController extends GetxController {
  final PrayerTimeModel todayPrayer = Get.arguments['prayersTime'];
  late String prayerName = 'Loading...';
  late String prayerTime = 'Loading...';

  RxString countdown = '- 00 : 00 : 00'.obs;
  Timer? _timer;
  bool _isPositiveTimer = false; // Flag for the 30-minute positive timer

  @override
  void onInit() {
    super.onInit();
    _updateNextPrayer();
    _initializeAndStartCountdown();
    _formatPrayerTime();
  }

  @override
  void onReady() {
    super.onReady();
    if (HiveService.instance.getPrayerTimes('yearlyPrayerTime') == null) {
      _savePrayersInHive('2024');
    }
    //TODO:
    // AudioPlayer().play(AssetSource('sounds/adhan.mp3'));
  }

  void _savePrayersInHive(String year) async {
    Map<String, dynamic> yearlyPrayerTime = await PrayerTimeCalendarByAddressApi
        .instance
        .getPrayerTimeCalendar('Tebessa, Algeria', year);
    HiveService.instance.setPrayerTimes(
      'yearlyPrayerTime',
      yearlyPrayerTime,
    );
  }

  void _formatPrayerTime() {
    prayerTime =
        '${prayerTime.substring(0, 2)} ${prayerTime.substring(2, 3)} ${prayerTime.substring(3)}';
  }

  DateTime _parsePrayerTime(String time) {
    DateTime now = DateTime.now();
    int hour = int.parse(time.substring(0, 2));
    int minute = int.parse(time.substring(3, 5));
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  void _initializeAndStartCountdown() {
    DateTime nextPrayerDateTime = _parsePrayerTime(prayerTime);

    if (nextPrayerDateTime.isBefore(DateTime.now())) {
      Duration passedDuration = DateTime.now().difference(nextPrayerDateTime);

      // Check if the prayer time has passed by less than 30 minutes
      if (passedDuration.inMinutes < 30) {
        // Format the passed time using _formatPositiveDuration
        countdown.value = _formatPositiveDuration(passedDuration);
        _isPositiveTimer = true; // Start count-up timer
      } else {
        // If more than 30 minutes have passed, move to the next day
        nextPrayerDateTime = nextPrayerDateTime.add(const Duration(days: 1));
        countdown.value = _formatDuration(nextPrayerDateTime
            .difference(DateTime.now())); // Set initial countdown
        _isPositiveTimer = false; // Start count-down timer
      }
    } else {
      // If the next prayer time is still in the future
      countdown.value = _formatDuration(nextPrayerDateTime
          .difference(DateTime.now())); // Set initial countdown
      _isPositiveTimer = false; // Start count-down timer
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
      _isPositiveTimer = true; // Switch to count-up timer
      countdown.value = "+ 00 : 00 : 00"; // Start the 30-minute positive timer
      _updateNextPrayer();
      _initializeAndStartCountdown();
    }
  }

  void _startCountUpTimer(DateTime initialPrayerEndTime) {
    _startAdhan();
    Duration positiveRemaining =
        DateTime.now().difference(initialPrayerEndTime);
    if (positiveRemaining.inMinutes < 30) {
      countdown.value = _formatPositiveDuration(positiveRemaining);
    } else {
      _isPositiveTimer = false; // Switch back to countdown
      _updateNextPrayer();
      _initializeAndStartCountdown();
    }
  }

  void _startAdhan() {
    DateTime nextPrayerDateTime = _parsePrayerTime(prayerTime);
    if (nextPrayerDateTime.isAtSameMomentAs(DateTime.now())) {
      AudioPlayer().play(AssetSource('sounds/adhan.mp3'));
    }
  }

  String _formatDuration(Duration duration) {
    String hours = duration.inHours.remainder(24).toString().padLeft(2, '0');
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "- $hours : $minutes : $seconds";
  }

  String _formatPositiveDuration(Duration duration) {
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "+ 00 : $minutes : $seconds";
  }

  void _updateNextPrayer() {
    DateTime now = DateTime.now();
    DateTime? nextPrayerDateTime;
    String? nextPrayerName;

    // Find the next prayer time that is after the current time
    todayPrayer.prayersTime.forEach((name, time) {
      // print('=================$name');
      DateTime prayerDateTime = _parsePrayerTime(time);
      if (prayerDateTime.isAfter(now) &&
          name != 'Sunset' &&
          name != 'Firstthird' &&
          name != 'Lastthird' &&
          name != 'Midnight') {
        if (nextPrayerDateTime == null ||
            prayerDateTime.isBefore(nextPrayerDateTime!)) {
          nextPrayerDateTime = prayerDateTime;
          nextPrayerName = name;
        }
      }
    });

    // If no prayer time remains for today, use the first prayer time for tomorrow but keep today’s date
    if (nextPrayerDateTime == null) {
      nextPrayerName = todayPrayer.prayersTime.keys.first;
      nextPrayerDateTime =
          _parsePrayerTime(todayPrayer.prayersTime[nextPrayerName]!);
    }

    // Update prayerName and prayerTime with the next prayer details
    if (nextPrayerName != null && nextPrayerDateTime != null) {
      prayerName = nextPrayerName!;
      prayerTime = _formatTime(nextPrayerDateTime!);
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
