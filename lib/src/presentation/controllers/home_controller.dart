import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/config/hive_service.dart';
import 'package:muslim/src/data/apis/prayer_time_calendar_api.dart';
import 'package:muslim/src/data/models/prayer_time_model.dart';

class HomeController extends GetxController {
  late PrayerTimeModel todayPrayer;
  late String prayerName = 'Loading...';
  late String prayerTime = 'Loading...';
  late DateTime prayerDay;

  RxString countdown = '- 00 : 00 : 00'.obs;
  Timer? _timer;
  bool _isPositiveTimer = false;

  @override
  void onInit() {
    super.onInit();
    todayPrayer = Get.arguments['prayersTime'];
    prayerDay = DateTime(
      int.parse(todayPrayer.date['gregorian']['year']),
      todayPrayer.date['gregorian']['month']['number'],
      int.parse(todayPrayer.date['gregorian']['day']),
    );
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
  }

  void _savePrayersInHive(String year) async {
    Map<String, dynamic> yearlyPrayerTime = await PrayerTimeCalendarApi.instance
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
    int hour = int.parse(time.substring(0, 2));
    int minute = int.parse(time.substring(3, 5));
    return DateTime(
        prayerDay.year, prayerDay.month, prayerDay.day, hour, minute);
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
        countdown.value =
            _formatDuration(nextPrayerDateTime.difference(DateTime.now()));
        _isPositiveTimer = false;
      }
    } else {
      countdown.value =
          _formatDuration(nextPrayerDateTime.difference(DateTime.now()));
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
    } else if (remaining.inSeconds == 0) {
      AudioPlayer().play(AssetSource('sounds/adhan.mp3'));
    } else {
      _isPositiveTimer = true;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _startCountUpTimer(nextPrayerDateTime);
      });
    }
  }

  void _startCountUpTimer(DateTime initialPrayerEndTime) {
    Duration positiveRemaining =
        DateTime.now().difference(initialPrayerEndTime);
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
        }
      }
    });

    if (nextPrayerDateTime == null) {
      now = now.add(const Duration(days: 1));
      todayPrayer = PrayerTimeModel.fromMap(HiveService.instance
              .getPrayerTimes('yearlyPrayerTime')[now.month.toString()]
          [now.day - 1]);
      nextPrayerName = todayPrayer.prayersTime.keys.first;
      nextPrayerDateTime =
          _parsePrayerTime(todayPrayer.prayersTime[nextPrayerName]!);
    }

    if (nextPrayerName != null && nextPrayerDateTime != null) {
      prayerName = nextPrayerName!;
      prayerTime = _formatTime(nextPrayerDateTime!);
    }
    update();
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
