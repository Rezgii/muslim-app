import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/utils/const/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/src/data/models/prayer_model.dart';
import 'package:muslim/src/data/models/time_line_model.dart';
import 'package:muslim/src/presentation/controllers/prayer_time_controller.dart';
import 'package:timeline_tile/timeline_tile.dart';

class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  final PrayerTimeController _controller = Get.put(PrayerTimeController());
  Widget _buildTimeline(List<TimeLine> statusList, List<PrayerModel> prayers) {
    return Row(
      children: [
        22.horizontalSpace,
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            children: List.generate(statusList.length, (index) {
              return TimelineTile(
                alignment: TimelineAlign.start,
                endChild: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      PrayerTimeWidget(
                        timeImage: prayers[index].timeImage,
                        prayerName: prayers[index].prayerName,
                        prayerTime: prayers[index].prayerTime.substring(0, 5),
                        soundIcon: prayers[index].soundIcon,
                      ),
                    ],
                  ),
                ),
                isFirst: index == 0,
                isLast: index == statusList.length - 1,
                beforeLineStyle: const LineStyle(
                  color: AppColors.primaryColor,
                  thickness: 3,
                ),
                afterLineStyle: const LineStyle(
                  color: AppColors.primaryColor,
                  thickness: 3,
                ),
                indicatorStyle: IndicatorStyle(
                    width: 25.r,
                    height: 25.r,
                    indicator: statusList[index].active
                        ? Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.circle,
                                color: Colors.white,
                                size: 15.r,
                              ),
                            ),
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.boxBlackBg,
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.primaryColor,
                                ),
                                top: BorderSide(
                                  color: AppColors.primaryColor,
                                ),
                                left: BorderSide(
                                  color: AppColors.primaryColor,
                                ),
                                right: BorderSide(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.circle,
                                color: AppColors.primaryColor,
                                size: 15.r,
                              ),
                            ),
                          )),
              );
            }),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today Prayer Time'),
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            //The place Widget
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.primaryColor,
                    size: 30.sp,
                  ),
                  10.horizontalSpace,
                  Text(
                    'Tebessa, Algeria',
                    style: TextStyle(fontSize: 20.sp),
                  )
                ],
              ),
            ),
            //The Date Widget
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 0, 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      //TODO: Open Month Calendar
                    },
                    icon: Icon(
                      Icons.calendar_month,
                      color: AppColors.primaryColor,
                      size: 30.sp,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 20.sp),
                      children: <TextSpan>[
                        TextSpan(
                          text: '${_controller.day} - ${_controller.dateHijri}',
                        ),
                        TextSpan(
                          text: '\n${_controller.date}',
                          style:
                              const TextStyle(color: AppColors.secondaryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //The next prayer + timer
            Text(
              _controller.prayerName,
              style: TextStyle(fontSize: 24.sp),
            ),
            Text(
              _controller.prayerTime,
              style:
                  TextStyle(fontSize: 18.sp, color: AppColors.secondaryColor),
            ),
            Obx(() => Text(
                  _controller.countdown.toString(),
                  style:
                      TextStyle(fontSize: 32.sp, color: AppColors.primaryColor),
                )),
            10.verticalSpace,
            //Today Prayer Time
            Container(
              width: 430.w,
              alignment: Alignment.center,
              // padding: REdgeInsets.fromLTRB(16),
              decoration: const BoxDecoration(
                color: AppColors.boxBlackBg,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  25.verticalSpace,
                  _buildTimeline([
                    //TODO: This time line
                    TimeLine(active: true, timestamp: Timestamp.now()),
                    TimeLine(active: false, timestamp: Timestamp.now()),
                    TimeLine(active: false, timestamp: Timestamp.now()),
                    TimeLine(active: false, timestamp: Timestamp.now()),
                    TimeLine(active: false, timestamp: Timestamp.now()),
                    TimeLine(active: false, timestamp: Timestamp.now()),
                    TimeLine(active: false, timestamp: Timestamp.now()),
                    TimeLine(active: false, timestamp: Timestamp.now()),
                  ], [
                    PrayerModel(
                      timeImage: 'assets/images/midnight.png',
                      prayerName: 'Imsak',
                      prayerTime: _controller.todayPrayer.prayersTime['Imsak'],
                      soundIcon: 'assets/images/mute.png',
                    ),
                    PrayerModel(
                      timeImage: 'assets/images/sunset.png',
                      prayerName: 'Al-Fadjr',
                      prayerTime: _controller.todayPrayer.prayersTime['Fajr'],
                      soundIcon: 'assets/images/volume.png',
                    ),
                    PrayerModel(
                      timeImage: 'assets/images/sunrise.png',
                      prayerName: 'Sunrise',
                      prayerTime:
                          _controller.todayPrayer.prayersTime['Sunrise'],
                      soundIcon: 'assets/images/mute.png',
                    ),
                    PrayerModel(
                      timeImage: 'assets/images/contrast.png',
                      prayerName: 'Dhuhr',
                      prayerTime: _controller.todayPrayer.prayersTime['Dhuhr'],
                      soundIcon: 'assets/images/volume.png',
                    ),
                    PrayerModel(
                      timeImage: 'assets/images/partly-cloudy.png',
                      prayerName: 'Al-Asr',
                      prayerTime: _controller.todayPrayer.prayersTime['Asr'],
                      soundIcon: 'assets/images/volume.png',
                    ),
                    PrayerModel(
                      timeImage: 'assets/images/sunset.png',
                      prayerName: 'Al-Maghrib',
                      prayerTime:
                          _controller.todayPrayer.prayersTime['Maghrib'],
                      soundIcon: 'assets/images/volume.png',
                    ),
                    PrayerModel(
                      timeImage: 'assets/images/half-moon.png',
                      prayerName: 'Al-Esha',
                      prayerTime: _controller.todayPrayer.prayersTime['Isha'],
                      soundIcon: 'assets/images/volume.png',
                    ),

                    PrayerModel(
                      timeImage: 'assets/images/midnight.png',
                      prayerName: 'Last Third',
                      prayerTime:
                          _controller.todayPrayer.prayersTime['Lastthird'],
                      soundIcon: 'assets/images/mute.png',
                    ),
                  ]),
                  10.verticalSpace,
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}

class PrayerTimeWidget extends StatelessWidget {
  const PrayerTimeWidget({
    super.key,
    required this.timeImage,
    required this.prayerName,
    required this.prayerTime,
    required this.soundIcon,
  });

  final String timeImage;
  final String prayerName;
  final String prayerTime;
  final String soundIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 334.w,
      height: 70.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Row(
        children: [
          15.horizontalSpace,
          Container(
            decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(15)),
            child: Image.asset(
              timeImage,
              height: 50.h,
            ),
          ),
          10.horizontalSpace,
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 18.sp, color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: prayerName,
                ),
                TextSpan(
                  text: '\n$prayerTime',
                  style: TextStyle(
                      fontSize: 16.sp, color: const Color(0xFFADABAB)),
                ),
              ],
            ),
          ),
          const Spacer(),
          Image.asset(
            soundIcon,
            height: 32.h,
          ),
          15.horizontalSpace,
        ],
      ),
    );
  }
}
