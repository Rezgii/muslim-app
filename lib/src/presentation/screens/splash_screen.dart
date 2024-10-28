import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/config/hive_service.dart';
import 'package:muslim/src/core/utils/const/app_colors.dart';
import 'package:muslim/src/data/apis/current_date_api.dart';
import 'package:muslim/src/data/apis/prayer_time_by_address_api.dart';
import 'package:muslim/src/data/models/prayer_time_model.dart';
import 'package:muslim/src/presentation/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late PrayerTimeModel _prayersTime;

  getDate() async {
    //TODO: Ask For User Data
    if (HiveService.instance.getPrayerTimes('yearlyPrayerTime') == null) {
      String date = await CurrentDateApi.instance.getDate('Africa/Algiers');
      _prayersTime = PrayerTimeModel.fromMap(await PrayerTimeByAddressApi
          .instance
          .getPrayerTime('Tebessa, Algeria', date));
    } else {
      DateTime today = DateTime.now();
      _prayersTime = PrayerTimeModel.fromMap(HiveService.instance
              .getPrayerTimes('yearlyPrayerTime')[today.month.toString()]
          [today.day - 1]);
      await Future.delayed(
        const Duration(seconds: 1),
      );
    }
  }

  initialise() async {
    await getDate();

    Get.to(() => const HomeScreen(), arguments: {
      'prayersTime': _prayersTime,
    });
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   'assets/images/logo.png',
              //   // scale: 5,
              // ),
              25.verticalSpace,
              Text(
                'Muslim',
                style: TextStyle(
                  fontSize: 24.sp,
                  color: AppColors.primaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
