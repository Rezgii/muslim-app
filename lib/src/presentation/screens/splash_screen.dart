import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/src/core/utils/const/app_colors.dart';
import 'package:muslim/src/core/utils/func/functions.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      initializeScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SvgPicture.asset(
              //     'assets/images/logo.svg',
              //     height: 350.h,
              //   ),
              25.verticalSpace,
              Text(
                'Muslim'.tr,
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
