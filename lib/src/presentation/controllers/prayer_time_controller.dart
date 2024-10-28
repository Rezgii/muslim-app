import 'dart:async';
import 'package:get/get.dart';
import 'package:muslim/src/data/models/prayer_time_model.dart';

class PrayerTimeController extends GetxController {
  final PrayerTimeModel todayPrayer = Get.arguments['prayersTime'];
  late String prayerName = '';
  late String prayerTime = '';
  late String date = '';
  late String dateHijri = '';
  late String day = '';

  RxString countdown = '- 00 : 00 : 00'.obs; // Observable for countdown display
  Timer? _timer; // Timer for the countdown

  @override
  void onInit() {
    super.onInit();

    _updateNextPrayer(); // Set the initial prayerName and prayerTime based on the next prayer
    _initializeCountdown();
    _startCountdown();
    _formatFields();
  }

  void _formatFields() {
    // Format all Fields
    date = todayPrayer.date['gregorian']['day'] +
        ' ' +
        todayPrayer.date['gregorian']['month']['en'] +
        ' ' +
        todayPrayer.date['gregorian']['year'];
    dateHijri = todayPrayer.date['hijri']['day'] +
        ' ' +
        todayPrayer.date['hijri']['month']['en'] +
        ' ' +
        todayPrayer.date['hijri']['year'];
    day = todayPrayer.date['gregorian']['weekday']['en'];
    prayerTime =
        '${prayerTime.substring(0, 2)} ${prayerTime.substring(2, 3)} ${prayerTime.substring(3)}';
  }

  DateTime _parsePrayerTime(String time) {
    DateTime now = DateTime.now();
    int hour = int.parse(time.substring(0, 2));
    int minute = int.parse(time.substring(3, 5));
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  void _startCountdown() {
    DateTime now = DateTime.now();
    DateTime nextPrayerDateTime =
        _parsePrayerTime(prayerTime); // Use the next prayer time

    if (nextPrayerDateTime.isBefore(now)) {
      // Update to the next day's prayer time if the prayer has passed
      nextPrayerDateTime = nextPrayerDateTime.add(const Duration(days: 1));
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      Duration remaining = nextPrayerDateTime.difference(DateTime.now());
      if (remaining.inSeconds > 0) {
        countdown.value = _formatDuration(remaining);
        update();
      } else {
        _updateNextPrayer();
        _initializeCountdown();
        _startCountdown();
      }
    });
  }

  String _formatDuration(Duration duration) {
    String hours = duration.inHours.remainder(24).toString().padLeft(2, '0');
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "- $hours : $minutes : $seconds";
  }

  void _initializeCountdown() {
    DateTime now = DateTime.now();
    DateTime nextPrayerDateTime =
        _parsePrayerTime(prayerTime); // Use the next prayer time

    if (nextPrayerDateTime.isBefore(now)) {
      // Update to the next day's prayer time if the prayer has passed
      nextPrayerDateTime = nextPrayerDateTime.add(const Duration(days: 1));
    }

    // Set the initial countdown value
    Duration remaining = nextPrayerDateTime.difference(now);
    countdown.value = _formatDuration(remaining);
  }

  void _updateNextPrayer() {
    DateTime now = DateTime.now();
    DateTime? nextPrayerDateTime;
    String? nextPrayerName;

    // Find the next prayer time that is after the current time
    todayPrayer.prayersTime.forEach((name, time) {
      DateTime prayerDateTime = _parsePrayerTime(time);
      if (prayerDateTime.isAfter(now) &&
          name != 'Sunset' &&
          name != 'Sunrise' &&
          name != 'Lastthird' &&
          name != 'Firstthird' &&
          name != 'Midnight') {
        if (nextPrayerDateTime == null ||
            prayerDateTime.isBefore(nextPrayerDateTime!)) {
          nextPrayerDateTime = prayerDateTime;
          nextPrayerName = name;
        }
      }
    });

    // If no prayer time remains for today, use the first prayer time for tomorrow
    if (nextPrayerDateTime == null) {
      nextPrayerName = todayPrayer.prayersTime.keys.first;
      nextPrayerDateTime =
          _parsePrayerTime(todayPrayer.prayersTime[nextPrayerName]!)
              .add(const Duration(days: 1));
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
    _timer?.cancel(); // Cancel the timer when the controller is disposed
    super.onClose();
  }
}
