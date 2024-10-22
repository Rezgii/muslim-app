import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/src/core/utils/func/functions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        initializeScreen(context);
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
