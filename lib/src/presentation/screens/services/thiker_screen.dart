import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/utils/const/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/src/presentation/screens/services/athkar_screen.dart';

class ThikerScreen extends StatelessWidget {
  const ThikerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Athkar Muslim"),
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ThekrWidget(
              title: 'Morning Athkar',
              time: '6:00 - 12:00',
              type: 'morning',
            ),
            25.verticalSpace,
            const ThekrWidget(
              title: 'Evening Athkar',
              time: 'Al-Asr - 00:00',
              type: 'evening',
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
    this.time,
    required this.type,
  });

  final String title;
  final String? time;
  final String type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const AthkarScreen(), arguments: {
          'type': type,
          'title': title,
        });
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
          children: [
            Text(
              title,
              style: TextStyle(color: AppColors.primaryColor, fontSize: 20.sp),
            ),
            const Spacer(),
            time != null
                ? Text(
                    time!,
                    style: TextStyle(
                        color: const Color(0xFF696D76), fontSize: 16.sp),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
