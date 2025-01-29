import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/utils/const/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/src/data/models/prayer_time_model.dart';
import 'package:muslim/src/presentation/controllers/home_controller.dart';
import 'package:muslim/src/presentation/screens/location_permission_screen.dart';
import 'package:muslim/src/presentation/screens/services/prayer_time_calendar_screen.dart';
import 'package:muslim/src/presentation/screens/services/prayer_time_screen.dart';
import 'package:muslim/src/presentation/screens/services/quran_screen.dart';
import 'package:muslim/src/presentation/screens/services/thiker_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController(), permanent: true);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return Scaffold(
      body: _buildHomeScreen(controller),
    );
  }

  SingleChildScrollView _buildHomeScreen(HomeController controller) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          SizedBox(
            height: 1.sh,
            width: 1.sw,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 250.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: .35),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                Opacity(
                  opacity: .2,
                  child: SvgPicture.asset(
                    'assets/images/mosque.svg',
                    width: 1.sw,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: REdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                25.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/images/user.svg',
                      height: 60.h,
                    ),
                    12.horizontalSpace,
                    Text(
                      'أهلا و سهلا',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 24.sp,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Get.to(() => const LocationPermissionScreen(),
                            duration: const Duration(milliseconds: 650),
                            transition: Transition.circularReveal,
                            curve: Curves.easeIn);
                      },
                      icon: Icon(
                        Icons.pin_drop,
                        size: 32.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                20.verticalSpace,
                Container(
                  height: 200.h,
                  width: 400.w,
                  padding: REdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  decoration: BoxDecoration(
                    color: AppColors.boxBlackBg,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 170.h,
                        width: 170.w,
                        padding: REdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.boxGreykBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.prayerName.tr,
                              style: TextStyle(fontSize: 22.sp),
                            ),
                            5.verticalSpace,
                            Text(
                              controller.convertTimeFormat(controller.prayerTime),
                              textDirection: TextDirection.ltr,
                              style: TextStyle(fontSize: 24.sp),
                            ),
                            5.verticalSpace,
                            Text(
                              controller.todayPrayer.date['gregorian']['date'],
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.secondaryColor),
                            ),
                            5.verticalSpace,
                            Center(
                              child: Obx(() => Text(controller.countdown.value,
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      fontSize: 24.sp,
                                      color: AppColors.primaryColor))),
                            )
                          ],
                        ),
                      ),
                      Transform.flip(
                        flipX: true,
                        child: SvgPicture.asset(
                          'assets/images/partly_cloudy.svg',
                          height: 150.h,
                        ),
                      )
                    ],
                  ),
                ),
                25.verticalSpace,
                Text(
                  'Features'.tr,
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 140.h,
                  ),
                  children: [
                    // const HomeItemWidget(
                    //   title: 'Quran',
                    //   img: 'assets/images/quran.svg',
                    //   routeName: '/quran',
                    // ),
                    const HomeItemWidget(
                      title: 'Thiker',
                      img: 'assets/images/tasbih.svg',
                      routeName: '/thiker',
                    ),
                    HomeItemWidget(
                      title: 'Prayer',
                      img: 'assets/images/time.svg',
                      routeName: '/prayer',
                      prayerTimeModel: controller.todayPrayer,
                    ),
                    HomeItemWidget(
                      title: 'Calendar',
                      img: 'assets/images/calendar.svg',
                      routeName: '/prayer',
                      prayerTimeModel: controller.todayPrayer,
                    ),
                  ],
                ),
                // Row(
                //   children: [
                //     Text(
                //       'Features',
                //       style: TextStyle(fontSize: 20.sp),
                //     ),
                //     const Spacer(),
                //     Text(
                //       'View All',
                //       style: TextStyle(
                //           fontSize: 16.sp,
                //           color: AppColors.primaryColor,
                //           fontWeight: FontWeight.bold),
                //     ),
                //   ],
                // ),
                // 25.verticalSpace,
                // Container(
                //   height: 210.h,
                //   width: 400.w,
                //   padding: REdgeInsets.all(15),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(25),
                //     gradient: const LinearGradient(
                //       begin: Alignment.topRight,
                //       end: Alignment.bottomLeft,
                //       colors: [
                //         Color(0xFFF6D27A),
                //         Color(0xFF907B47),
                //         Color(0xFF494232),
                //       ],
                //       stops: [
                //         0,
                //         76,
                //         100,
                //       ],
                //     ),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Container(
                //         height: 30.h,
                //         width: 100.w,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(22),
                //           color: Colors.black.withOpacity(.5),
                //         ),
                //         child: const Center(
                //             child: Text(
                //           'Daily Doua',
                //           style: TextStyle(color: AppColors.primaryColor),
                //         )),
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           Flexible(
                //             child: Text(
                //               'Doua For Ahel Gazza',
                //               style: TextStyle(fontSize: 32.sp),
                //             ),
                //           ),
                //           SvgPicture.asset(
                //             'assets/images/praying.svg',
                //             height: 150.h,
                //           )
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                50.verticalSpace
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeItemWidget extends StatelessWidget {
  const HomeItemWidget({
    super.key,
    required this.title,
    required this.img,
    required this.routeName,
    this.prayerTimeModel,
  });

  final String title;
  final String img;
  final String routeName;
  final PrayerTimeModel? prayerTimeModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Quran') {
          Get.to(() => const QuranScreen(),
              duration: const Duration(milliseconds: 650),
              transition: Transition.circularReveal,
              curve: Curves.easeIn);
        } else if (title == 'Thiker') {
          Get.to(() => const ThikerScreen(),
              duration: const Duration(milliseconds: 650),
              transition: Transition.circularReveal,
              curve: Curves.easeIn);
        } else if (title == 'Calendar') {
          Get.to(() => const PrayerTimeCalendarScreen(),
              duration: const Duration(milliseconds: 650),
              transition: Transition.circularReveal,
              curve: Curves.easeIn);
        } else {
          Get.to(() => const PrayerTimeScreen(),
              arguments: {
                'isToday': true,
                'prayersTime': prayerTimeModel,
              },
              duration: const Duration(milliseconds: 650),
              transition: Transition.circularReveal,
              curve: Curves.easeIn);
        }
      },
      child: Container(
        height: 140.h,
        width: 113.w,
        margin: REdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: AppColors.boxGreykBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              img,
              height: 75.h,
            ),
            Text(
              title.tr,
              style: TextStyle(fontSize: 20.sp),
            )
          ],
        ),
      ),
    );
  }
}
