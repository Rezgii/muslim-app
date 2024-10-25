import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/utils/const/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/src/presentation/controllers/athkar_controller.dart';
import 'package:vibration/vibration.dart';

class AthkarScreen extends StatelessWidget {
  const AthkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AthkarController controller = Get.put(AthkarController());

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title),
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.backgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: GetBuilder<AthkarController>(
              init: AthkarController(),
              builder: (controller) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.athkar.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        if (await Vibration.hasVibrator() != null) {
                          Vibration.vibrate(duration: 100);
                          if (controller.athkar[index].repeat > 1) {
                            controller.athkar[index].repeat =
                                controller.athkar[index].repeat - 1;
                          } else {
                            controller.athkar.removeAt(index);
                          }
                          controller.update();
                        }
                      },
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                padding: REdgeInsets.all(20),
                                margin: REdgeInsets.only(bottom: 35),
                                width: 400.w,
                                decoration: BoxDecoration(
                                  color: AppColors.boxBlackBg,
                                  borderRadius: BorderRadius.circular(15),
                                  border:
                                      Border.all(color: AppColors.primaryColor),
                                ),
                                child: Text(
                                  controller.athkar[index].thiker,
                                  style: TextStyle(fontSize: 20.sp),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: 130.w,
                                  padding: REdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.boxBlackBg,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: AppColors.primaryColor),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text('Repeat'),
                                      Container(
                                        width: 30.w,
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: AppColors.primaryColor),
                                        ),
                                        child: Center(
                                            child: GetBuilder<AthkarController>(
                                          init: AthkarController(),
                                          initState: (controller) {},
                                          builder: (controller) {
                                            return Text(controller
                                                .athkar[index].repeat
                                                .toString());
                                          },
                                        )),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          20.verticalSpace,
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
