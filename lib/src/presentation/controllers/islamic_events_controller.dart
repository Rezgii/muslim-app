import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:muslim/src/data/models/islamic_event_model.dart';
import 'package:muslim/src/core/utils/const/islamic_events.dart';

class IslamicEventsController extends GetxController {
  List<IslamicEventModel> events = [];
  HijriCalendar todayHijri = HijriCalendar.now();

  // Get Events and Order Them
  @override
  void onInit() { 
    for (var event in islamicEvents) {
      events.add(IslamicEventModel.fromMap(event));
    }

    events.sort((a, b) {
      DateTime dateA = hijriToGregorian(a.hijriMonth, a.hijriDay);
      DateTime dateB = hijriToGregorian(b.hijriMonth, b.hijriDay);

      int daysLeftA = int.parse(
        getDaysLeft(dateA, a.hijriMonth, a.hijriDay).split(" ")[0],
      );
      int daysLeftB = int.parse(
        getDaysLeft(dateB, b.hijriMonth, b.hijriDay).split(" ")[0],
      );

      return daysLeftA.compareTo(daysLeftB);
    });
    super.onInit();
  }

  DateTime hijriToGregorian(int hijriMonth, int hijriDay) {
    HijriCalendar hijriDate =
        HijriCalendar()
          ..hYear = HijriCalendar.now().hYear
          ..hMonth = hijriMonth
          ..hDay = hijriDay;

    return hijriDate.hijriToGregorian(
      hijriDate.hYear,
      hijriDate.hMonth,
      hijriDate.hDay,
    );
  }

  // Format date (ex: "25 March")
  String formateGregorianDate(DateTime gregorianDate) {
    const List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    int day = gregorianDate.day;
    String month = months[gregorianDate.month - 1];

    return "$day\n${month.tr}";
  }

  String getDaysLeft(DateTime gregorianDate, int hijriMonth, int hijriDay) {
    DateTime today = DateTime.now();

    // If the event has passed, calculate for the next year
    if (gregorianDate.isBefore(today)) {
      HijriCalendar nextHijriDate =
          HijriCalendar()
            ..hYear = HijriCalendar.now().hYear + 1
            ..hMonth = hijriMonth
            ..hDay = hijriDay;

      DateTime nextGregorianDate = nextHijriDate.hijriToGregorian(
        nextHijriDate.hYear,
        nextHijriDate.hMonth,
        nextHijriDate.hDay,
      );

      gregorianDate = nextGregorianDate;
    }

    int difference = gregorianDate.difference(today).inDays;

    return "$difference ${'Days Left'.tr}";
  }
}
