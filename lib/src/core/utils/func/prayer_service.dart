

// import 'dart:developer';

// import 'package:flutter/services.dart';

// class PrayerService {
//   static const platform =  MethodChannel('myService');

//   Future<void> startService()async{
//     try{
//       await platform.invokeMethod('startService', {
//         'prayerName': 'MOGHRIIIIIIIIIIIB',
//         'countdownTime': 3600,
//       }).then((value) {
//         log("SERVICE STARTED");
//       },);
//     }on PlatformException catch (ex){
//       log("Platfrom Exception : ${ex.message}");
//     }
//   }

//   Future<void> stopService()async{
//     try{
//       await platform.invokeMethod("stopService");
//     }on PlatformException catch (ex){
//       log("Platfrom Exception : ${ex.message}");
//     }
//   }

// }