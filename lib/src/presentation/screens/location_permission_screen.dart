import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/config/hive_service.dart';
import 'package:muslim/src/core/config/theme/app_colors.dart';
import 'package:muslim/src/core/utils/func/functions.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  Position? location;

  Future<bool> requestLocationPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return false;
    }

    location = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
    );

    await HiveService.instance.setSetting('location', true);
    await HiveService.instance.setSetting('locationData', {
      'latitude': location!.latitude.toString(),
      'longitude': location!.longitude.toString(),
    });

    return true;
  }

  getLocation() async {
    if (await requestLocationPermission()) {
      //permission granted and service enabled
      if (location != null) {
        initializeScreen();
      }
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: REdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              SvgPicture.asset(
                'assets/images/location.svg',
                height: 180.h,
                width: 230.w,
              ),
              50.verticalSpace,
              Text('Allow your location'.tr, style: TextStyle(fontSize: 24.sp)),
              15.verticalSpace,
              Text(
                'We will need your location to \ngive you better experience'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              ),
              50.verticalSpace,
              SizedBox(
                width: 320.w,
                height: 50.h,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      AppColors.primaryColor,
                    ),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const Dialog(
                          backgroundColor: Colors.transparent,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    );
                    await getLocation();
                  },
                  child: Text(
                    "Sure, I'd like that".tr,
                    style: const TextStyle(color: AppColors.backgroundColor),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
