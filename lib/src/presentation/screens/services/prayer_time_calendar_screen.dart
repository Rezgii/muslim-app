import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/config/hive_service.dart';
import 'package:muslim/src/core/utils/const/app_colors.dart';
import 'package:muslim/src/data/models/prayer_time_model.dart';
import 'package:muslim/src/presentation/screens/services/prayer_time_screen.dart';

class PrayerTimeCalendarScreen extends StatefulWidget {
  const PrayerTimeCalendarScreen({super.key});

  @override
  State<PrayerTimeCalendarScreen> createState() =>
      _PrayerTimeCalendarScreenState();
}

class _PrayerTimeCalendarScreenState extends State<PrayerTimeCalendarScreen> {
  final DateTime _currentDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  String getArabicMonthName(int month) {
    List<String> arabicMonths = [
      "جانفي",
      "فيفري",
      "مارس",
      "أفريل",
      "ماي",
      "جوان",
      "جويلية",
      "أوت",
      "سبتمبر",
      "أكتوبر",
      "نوفمبر",
      "ديسمبر",
    ];
    return arabicMonths[month - 1]; // month is 1-based index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prayer Time Calender'.tr),
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              30.verticalSpace,
              SizedBox(
                height: 500.h,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CalendarCarousel<Event>(
                    locale: Get.locale!.languageCode,
                    minSelectedDate: DateTime(_currentDate.year, 1, 1),
                    maxSelectedDate: DateTime(_currentDate.year, 12, 31),
                    pageSnapping: true,
                    selectedDayButtonColor: AppColors.primaryColor,
                    selectedDayBorderColor: AppColors.primaryColor,
                    selectedDayTextStyle: const TextStyle(
                      color: AppColors.boxBlackBg,
                    ),
                    weekdayTextStyle: const TextStyle(color: Colors.white),
                    headerText:
                        "${getArabicMonthName(_selectedDate.month)} ${_selectedDate.year}",
                    headerTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                    ),
                    iconColor: AppColors.primaryColor,
                    daysTextStyle: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                    onDayPressed: (DateTime date, List<Event> events) {
                      Get.to(
                        () => const PrayerTimeScreen(),
                        arguments: {
                          'isToday': false,
                          'prayersTime': getPrayerTime(date),
                        },
                        duration: const Duration(milliseconds: 650),
                        transition: Transition.circularReveal,
                        curve: Curves.easeIn,
                      );
                    },
                    weekendTextStyle: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                    customDayBuilder: (
                      bool isSelectable,
                      int index,
                      bool isSelectedDay,
                      bool isToday,
                      bool isPrevMonthDay,
                      TextStyle textStyle,
                      bool isNextMonthDay,
                      bool isThisMonthDay,
                      DateTime day,
                    ) {
                      return null;

                      //For events
                      // if (day.day == 15) {
                      //   return const Center(
                      //     child: Icon(Icons.local_airport),
                      //   );
                      // } else {
                      //   return null;
                      // }
                    },
                    onCalendarChanged: (DateTime newDate) {
                      setState(() {
                        _selectedDate = newDate;
                      });
                    },
                    weekFormat: false,
                    height: 420.h,
                    selectedDateTime: _currentDate,
                    daysHaveCircularBorder: true,
                  ),
                ),
                // child: CarouselView(
                //   itemSnapping: true,
                //   onTap: null,
                //   itemExtent: 120.w,
                //   children: List.generate(
                //     octoberDays.length,
                //     (index) {
                //       return DayWidget(
                //           day: octoberDays[index],
                //           dateHijri: octoberHijri[index]);
                //     },
                //   ),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PrayerTimeModel getPrayerTime(DateTime date) {
    return PrayerTimeModel.fromMap(
      HiveService.instance.getPrayerTimes('yearlyPrayerTime')[date.month
          .toString()][date.day - 1],
    );
  }
}
