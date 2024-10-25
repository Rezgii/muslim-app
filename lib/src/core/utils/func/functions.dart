import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/config/hive_service.dart';
import 'package:muslim/src/presentation/screens/home_screen.dart';

bool get isIntroShown => HiveService.instance.getSetting('intro') ?? false;
bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

void initializeScreen(BuildContext context) {
  Get.to(() => const HomeScreen());
  // if (!isIntroShown) {
  //   Navigator.pushReplacementNamed(context, '/onBoarding');
  // } else if (isLoggedIn) {
  //   Navigator.pushReplacementNamed(context, '/navigation');
  // } else {
  //   Navigator.pushReplacementNamed(context, '/waiting');
  // }
}
