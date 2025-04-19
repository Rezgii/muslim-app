import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/config/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/src/presentation/screens/services/athkar_screen.dart';

class ThikerScreen extends StatelessWidget {
  const ThikerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Athkar Muslim".tr),
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ThekrWidget(
              title: 'Morning Athkar'.tr,
              type: 'morning',
            ),
            25.verticalSpace,
            ThekrWidget(
              title: 'Evening Athkar'.tr,
              type: 'evening',
            ),
            25.verticalSpace,
            ThekrWidget(
              title: 'Wake up Athkar'.tr,
              type: 'wakeup',
            ),
            25.verticalSpace,
            ThekrWidget(
              title: 'Sleep Athkar'.tr,
              type: 'sleep',
            ),
            25.verticalSpace,
            ThekrWidget(
              title: 'After Praying Athkar'.tr,
              type: 'praying',
            ),
          ],
        ),
      )),
    );
  }
}

class ThekrWidget extends StatelessWidget {
  const ThekrWidget({
    super.key,
    required this.title,
    required this.type,
  });

  final String title;
  final String type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const AthkarScreen(),
            arguments: {
              'type': type,
              'title': title,
            },
            duration: const Duration(milliseconds: 650),
            transition: Transition.circularReveal,
            curve: Curves.easeIn);
      },
      child: Container(
        height: 75.h,
        width: 400.w,
        padding: REdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.boxBlackBg,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(color: AppColors.primaryColor, fontSize: 20.sp),
            ),
          ],
        ),
      ),
    );
  }
}
