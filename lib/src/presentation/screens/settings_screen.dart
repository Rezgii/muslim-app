import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/config/theme/app_colors.dart';
import 'package:muslim/src/presentation/screens/feedback_screen.dart';
import 'package:muslim/src/presentation/screens/location_permission_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_SettingItem> settings = [
      _SettingItem(
        title: 'Change Location'.tr,
        icon: Icons.pin_drop,
        onTap:
            () => Get.to(
              () => const LocationPermissionScreen(),
              duration: const Duration(milliseconds: 650),
              transition: Transition.circularReveal,
              curve: Curves.easeIn,
            ),
      ),
      // _SettingItem(
      //   title: 'Change Theme'.tr,
      //   icon: Icons.color_lens,
      //   onTap: () => Get.find<ThemeController>().toggleTheme(),
      // ),
      _SettingItem(
        title: 'Report a Problem'.tr,
        icon: Icons.report_problem,
        onTap:
            () => Get.to(
              () => const FeedbackScreen(isFeedback: false),
              duration: const Duration(milliseconds: 650),
              transition: Transition.circularReveal,
              curve: Curves.easeIn,
            ),
      ),
      _SettingItem(
        title: 'Send Feedback'.tr,
        icon: Icons.feedback,
        onTap:
            () => Get.to(
              () => const FeedbackScreen(isFeedback: true,),
              duration: const Duration(milliseconds: 650),
              transition: Transition.circularReveal,
              curve: Curves.easeIn,
            ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'.tr),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: settings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = settings[index];
          return ListTile(
            tileColor: Colors.transparent,
            leading: Icon(item.icon, color: AppColors.primaryColor),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            title: Text(
              item.title.tr,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: item.onTap,
          );
        },
      ),
    );
  }
}

class _SettingItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SettingItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
