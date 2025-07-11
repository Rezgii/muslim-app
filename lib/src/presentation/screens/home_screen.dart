import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/config/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/src/core/utils/func/functions.dart';
import 'package:muslim/src/data/models/prayer_time_model.dart';
import 'package:muslim/src/presentation/controllers/home_controller.dart';
import 'package:muslim/src/presentation/screens/services/islamic_events_screen.dart';
import 'package:muslim/src/presentation/screens/services/prayer_time_calendar_screen.dart';
import 'package:muslim/src/presentation/screens/services/prayer_time_screen.dart';
import 'package:muslim/src/presentation/screens/services/quran_screen.dart';
import 'package:muslim/src/presentation/screens/services/thiker_screen.dart';
import 'package:muslim/src/presentation/screens/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController(), permanent: true);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const BackgroundWidget(),
            Padding(
              padding: REdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  25.verticalSpace,
                  const HeaderWidget(),
                  20.verticalSpace,
                  PrayerTimeWidget(controller: controller),
                  10.verticalSpace,
                  Text(
                    'Features'.tr,
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  FeaturesGridWidget(controller: controller),
                  GetBuilder<HomeController>(
                    init: HomeController(),
                    builder: (_) {
                      if (controller.surah == null) {
                        return const SizedBox();
                      }
                      return const CarouselFeatureWidget();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// a carousel widget for aya or douaa (like ads and promotions)
class CarouselFeatureWidget extends StatelessWidget {
  const CarouselFeatureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: const [AyaWidget()],
      options: CarouselOptions(
        autoPlay: false,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
        pauseAutoPlayOnTouch: true,
      ),
    );
  }
}

class AyaWidget extends StatelessWidget {
  const AyaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find<HomeController>();
    return Container(
      height: 210.h,
      width: 400.w,
      padding: REdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFF6D27A), Color(0xFF907B47), Color(0xFF494232)],
          stops: [0, 76, 100],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.black.withAlpha((0.5 * 255).toInt()),
            ),
            child: Center(
              child: Text(
                'Aya of The Day'.tr,
                style: const TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                controller.surah!.verses[controller.ayaNumber!]['text']['ar'] ??
                    '',
                style: TextStyle(fontSize: 20.sp, color: Colors.black),
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ),
          const Spacer(),

          Text(
            "${controller.surah!.name['ar']} (السورة رقم ${controller.surah!.number} - ${controller.surah!.place['ar']} - الآية ${controller.ayaNumber!.toString()})",
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class DuaaWidget extends StatelessWidget {
  const DuaaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210.h,
      width: 400.w,
      padding: REdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFF6D27A), Color(0xFF907B47), Color(0xFF494232)],
          stops: [0, 76, 100],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.black.withAlpha((0.5 * 255).toInt()),
            ),
            child: const Center(
              child: Text(
                'Duaa of The Day',
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  "ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَٰلَمِينَ",
                  style: TextStyle(fontSize: 32.sp),
                ),
              ),
              SvgPicture.asset('assets/images/praying.svg', height: 120.h),
            ],
          ),
        ],
      ),
    );
  }
}

class FeaturesGridWidget extends StatelessWidget {
  const FeaturesGridWidget({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 15),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisExtent: 120.h,
      ),
      children: [
        // const HomeItemWidget(
        //   title: 'Quran',
        //   img: 'assets/images/quran.svg',
        //   routeName: '/quran',
        // ),
        const HomeItemWidget(title: 'Thiker', img: 'assets/images/tasbih.svg'),
        HomeItemWidget(
          title: 'Prayer',
          img: 'assets/images/time.svg',
          prayerTimeModel: controller.todayPrayer,
        ),
        HomeItemWidget(
          title: 'Calendar',
          img: 'assets/images/calendar.svg',
          prayerTimeModel: controller.todayPrayer,
        ),
        HomeItemWidget(
          title: 'Events',
          img: 'assets/images/event.svg',
          prayerTimeModel: controller.todayPrayer,
        ),
        // HomeItemWidget(
        //   title: 'Qiblah',
        //   img: 'assets/images/qiblah.svg',
        //   prayerTimeModel: controller.todayPrayer,
        // ),
      ],
    );
  }
}

class PrayerTimeWidget extends StatelessWidget {
  const PrayerTimeWidget({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    color: AppColors.secondaryColor,
                  ),
                ),
                5.verticalSpace,
                Center(
                  child: Obx(
                    () => FittedBox(
                      child: Text(
                        controller.countdown.value,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 100.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Transform.flip(
            flipX: true,
            child: SvgPicture.asset(
              'assets/images/partly_cloudy.svg',
              height: 150.h,
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset('assets/images/user.svg', height: 60.h),
        12.horizontalSpace,
        Text(
          // 'أهلا و سهلا',
          "${country.toString()}, ${city.toString()}",
          style: TextStyle(color: AppColors.primaryColor, fontSize: 24.sp),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            Get.to(
              () => const SettingsScreen(),
              duration: const Duration(milliseconds: 650),
              transition: Transition.circularReveal,
              curve: Curves.easeIn,
            );
          },
          icon: Icon(
            Icons.settings,
            size: 32.sp,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            child: SvgPicture.asset('assets/images/mosque.svg', width: 1.sw),
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
    this.prayerTimeModel,
  });

  final String title;
  final String img;
  final PrayerTimeModel? prayerTimeModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Quran') {
          Get.to(
            () => const QuranScreen(),
            duration: const Duration(milliseconds: 650),
            transition: Transition.circularReveal,
            curve: Curves.easeIn,
          );
        } else if (title == 'Thiker') {
          Get.to(
            () => const ThikerScreen(),
            duration: const Duration(milliseconds: 650),
            transition: Transition.circularReveal,
            curve: Curves.easeIn,
          );
        } else if (title == 'Calendar') {
          Get.to(
            () => const PrayerTimeCalendarScreen(),
            duration: const Duration(milliseconds: 650),
            transition: Transition.circularReveal,
            curve: Curves.easeIn,
          );
        } else if (title == 'Events') {
          Get.to(
            () => const IslamicEventsScreen(),
            duration: const Duration(milliseconds: 650),
            transition: Transition.circularReveal,
            curve: Curves.easeIn,
          );
        }
        // else if (title == 'Qiblah') {
        //   Get.to(
        //     () => const QiblahScreen(),
        //     duration: const Duration(milliseconds: 650),
        //     transition: Transition.circularReveal,
        //     curve: Curves.easeIn,
        //   );
        // }
        else {
          Get.to(
            () => const PrayerTimeScreen(),
            arguments: {'isToday': true, 'prayersTime': prayerTimeModel},
            duration: const Duration(milliseconds: 650),
            transition: Transition.circularReveal,
            curve: Curves.easeIn,
          );
        }
      },
      child: Container(
        height: 120.h,
        width: 93.w,
        margin: REdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: AppColors.boxGreykBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(img, height: 65.h),
            Text(title.tr, style: TextStyle(fontSize: 20.sp)),
          ],
        ),
      ),
    );
  }
}
