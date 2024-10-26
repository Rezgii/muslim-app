import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
  String _date = '';

  getDate() async {
    //TODO: Ask For User Data
    _date = await CurrentDateApi.instance.getDate('Africa/Algiers');
    _prayersTime = PrayerTimeModel.fromMap(await PrayerTimeByAddressApi.instance
        .getPrayerTime('Tebessa, Algeria', _date));
  }

  @override
  void initState() {
    super.initState();
    getDate();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        // initializeScreen(context);
        Get.to(() => const HomeScreen(), arguments: {
          'date': _date,
          'prayersTime': _prayersTime,
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
