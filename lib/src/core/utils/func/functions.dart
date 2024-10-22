import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muslim/src/core/config/hive_service.dart';

bool get isIntroShown => HiveService.instance.getSetting('intro') ?? false;
bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

void initializeScreen(BuildContext context) {
  Navigator.pushReplacementNamed(context, '/home');
  // if (!isIntroShown) {
  //   Navigator.pushReplacementNamed(context, '/onBoarding');
  // } else if (isLoggedIn) {
  //   Navigator.pushReplacementNamed(context, '/navigation');
  // } else {
  //   Navigator.pushReplacementNamed(context, '/waiting');
  // }
}
