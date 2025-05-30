import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/config/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim/src/data/models/thiker_model.dart';
import 'package:muslim/src/presentation/controllers/athkar_controller.dart';
import 'package:vibration/vibration.dart';

class AthkarScreen extends StatefulWidget {
  const AthkarScreen({super.key});

  @override
  State<AthkarScreen> createState() => _AthkarScreenState();
}

class _AthkarScreenState extends State<AthkarScreen> {
  final AthkarController _controller = Get.put(AthkarController());
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final Tween<Offset> _offset = Tween(
    begin: const Offset(1, 0),
    end: const Offset(0, 0),
  );
  bool _isRemoving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_controller.title.tr),
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.backgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: GetBuilder<AthkarController>(
              init: AthkarController(),
              builder: (controller) {
                return _controller.athkar.isEmpty
                    ? const FinishAthkaWidget()
                    : AnimatedList(
                      key: _listKey,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      initialItemCount: controller.athkar.length,
                      itemBuilder: (context, index, animation) {
                        return _buildThikerItemWidget(
                          controller.athkar[index],
                          index,
                          animation,
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

  Widget _buildThikerItemWidget(
    ThikerModel thiker,
    int index,
    Animation<double> animation,
  ) {
    return SlideTransition(
      position: animation.drive(_offset),
      child: Center(
        child: GestureDetector(
          onTap: () async {
            if (!_isRemoving && await Vibration.hasVibrator()) {
              Vibration.vibrate(duration: 100);
              if (thiker.repeat > 1) {
                thiker.repeat = thiker.repeat - 1;
              } else {
                removeItem(index);
              }
              _controller.update();
            }
          },
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: REdgeInsets.all(32),
                    margin: REdgeInsets.only(bottom: 35),
                    width: 400.w,
                    decoration: BoxDecoration(
                      color: AppColors.boxBlackBg,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.primaryColor),
                    ),
                    child: Text(
                      thiker.thiker,
                      style: TextStyle(fontSize: 22.sp),
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
                        border: Border.all(color: AppColors.primaryColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Repeat'.tr),
                          Container(
                            width: 35.w,
                            height: 35.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primaryColor),
                            ),
                            child: Center(
                              child: Text(thiker.repeat.toString()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  void removeItem(int index) {
    _isRemoving = true;
    final itemToRemove = _controller.athkar[index];
    _controller.athkar.removeAt(index);

    _listKey.currentState?.removeItem(index, (context, animation) {
      return _buildThikerItemWidget(itemToRemove, index, animation);
    }, duration: const Duration(milliseconds: 350));

    Future.delayed(const Duration(milliseconds: 400), () {
      _isRemoving = false;
    });
  }
}

class FinishAthkaWidget extends StatelessWidget {
  const FinishAthkaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          50.verticalSpace,
          AnimatedTextKit(
            repeatForever: false,
            totalRepeatCount: 1,
            animatedTexts: [
              TyperAnimatedText(
                'You finished all Athakr.\nYou are good to go.'.tr,
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontSize: 22.sp,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}