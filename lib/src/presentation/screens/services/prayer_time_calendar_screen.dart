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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    minSelectedDate: DateTime(2024, 1, 1),
                    maxSelectedDate: DateTime(2024, 12, 31),
                    pageSnapping: true,
                    selectedDayButtonColor: AppColors.primaryColor,
                    selectedDayBorderColor: AppColors.primaryColor,
                    selectedDayTextStyle:
                        const TextStyle(color: AppColors.boxBlackBg),
                    weekdayTextStyle: const TextStyle(color: Colors.white),
                    headerTextStyle:
                        TextStyle(color: Colors.white, fontSize: 24.sp),
                    iconColor: AppColors.primaryColor,
                    daysTextStyle: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                    onDayPressed: (DateTime date, List<Event> events) {
                      Get.to(() => const PrayerTimeScreen(), arguments: {
                        'isToday': false,
                        'prayersTime': getPrayerTime(date)
                      });
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
    return PrayerTimeModel.fromMap(HiveService.instance
            .getPrayerTimes('yearlyPrayerTime')[date.month.toString()]
        [date.day - 1]);
  }
}

// class DaysWidget extends StatelessWidget {
//   const DaysWidget({
//     super.key,
//     required this.days,
//     required this.hijriDates,
//   });

//   final List<String> days;
//   final List<String> hijriDates;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.sizeOf(context).width,
//       child: Wrap(
//         alignment: WrapAlignment.center,
//         children: List.generate(
//           days.length,
//           (index) {
//             return DayWidget(
//               day: days[index],
//               dateHijri: hijriDates[index],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class DayWidget extends StatelessWidget {
//   const DayWidget({
//     super.key,
//     required this.day,
//     required this.dateHijri,
//   });

//   final String day;
//   final String dateHijri;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: REdgeInsets.symmetric(horizontal: 10, vertical: 15),
//       width: 120.w,
//       height: 70.h,
//       decoration: BoxDecoration(
//         color: day == DateTime.now().day.toString()
//             ? AppColors.primaryColor
//             : Colors.transparent,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: AppColors.primaryColor,
//         ),
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Text(
//               day,
//               style: TextStyle(
//                   fontSize: 22.sp,
//                   color: day == DateTime.now().day.toString()
//                       ? AppColors.backgroundColor
//                       : Colors.white),
//             ),
//             Text(
//               dateHijri,
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 color: const Color(0xFF696D76),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
