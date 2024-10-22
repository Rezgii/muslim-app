import 'package:flutter/material.dart';
import 'package:muslim/src/core/utils/const/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            height: 250.h,
            decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(.35),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
          ),
          Padding(
            padding: REdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  25.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/user.png',
                        height: 60.h,
                      ),
                      12.horizontalSpace,
                      const Text(
                        'أهلا و سهلا',
                        style: TextStyle(
                            color: AppColors.primaryColor, fontSize: 24),
                      )
                    ],
                  ),
                  20.verticalSpace,
                  Container(
                    height: 220.h,
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
                          height: 190.h,
                          width: 160.w,
                          padding: REdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.boxGreykBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'DHUHR',
                                style: TextStyle(fontSize: 22),
                              ),
                              5.verticalSpace,
                              const Text(
                                '- 01 : 25 : 30',
                                style: TextStyle(fontSize: 22),
                              ),
                              5.verticalSpace,
                              const Text(
                                '12 : 13 PM',
                                style: TextStyle(fontSize: 22),
                              ),
                              5.verticalSpace,
                              const Text(
                                '10/20/2024',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.secondaryColor),
                              ),
                            ],
                          ),
                        ),
                        Transform.flip(
                          flipX: true,
                          child: Image.asset(
                            'assets/images/partly-cloudy.png',
                            height: 150.h,
                          ),
                        )
                      ],
                    ),
                  ),
                  50.verticalSpace,
                  Wrap(
                    children: [
                      const HomeItemWidget(
                        title: 'Quran',
                        img: 'assets/images/quran.png',
                        routeName: '/quran',
                      ),
                      15.horizontalSpace,
                      const HomeItemWidget(
                        title: 'Thiker',
                        img: 'assets/images/tasbih.png',
                        routeName: '/thiker',
                      ),
                      15.horizontalSpace,
                      const HomeItemWidget(
                        title: 'Prayer',
                        img: 'assets/images/time.png',
                        routeName: '/prayer',
                      ),
                    ],
                  ),
                  50.verticalSpace,
                  const Row(
                    children: [
                      Text(
                        'Features',
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      Text(
                        'View All',
                        style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  25.verticalSpace,
                  Container(
                    height: 210.h,
                    width: 400.w,
                    padding: REdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFFF6D27A),
                          Color(0xFF907B47),
                          Color(0xFF494232),
                        ],
                        stops: [
                          0,
                          76,
                          100,
                        ],
                      ),
                    ),
                    child: Column(
                      // alignment: Alignment.topLeft,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 30.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: Colors.black.withOpacity(.5),
                          ),
                          child: const Center(
                              child: Text(
                            'Daily Doua',
                            style: TextStyle(color: AppColors.primaryColor),
                          )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Flexible(
                              child: Text(
                                'Doua For Ahel Gazza',
                                style: TextStyle(fontSize: 32),
                              ),
                            ),
                            Image.asset(
                              'assets/images/praying.png',
                              height: 150.h,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class HomeItemWidget extends StatelessWidget {
  const HomeItemWidget({
    super.key,
    required this.title,
    required this.img,
    required this.routeName,
  });

  final String title;
  final String img;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        height: 140.h,
        width: 113.w,
        decoration: BoxDecoration(
          color: AppColors.boxGreykBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              img,
              height: 75.h,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
