// import 'dart:async';
// import 'dart:math' show pi;

// import 'package:flutter/material.dart';
// import 'package:flutter_qiblah/flutter_qiblah.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:geolocator/geolocator.dart';

// import 'package:muslim/src/presentation/screens/services/loading_indicator.dart';
// import 'package:muslim/src/presentation/screens/services/location_error_widget.dart';

// class QiblahScreen extends StatefulWidget {
//   const QiblahScreen({super.key});

//   @override
//   State<QiblahScreen> createState() => _QiblahScreenState();
// }

// class _QiblahScreenState extends State<QiblahScreen> {
//   Future<bool> _checkPermissionsAndSensors() async {
//     // Check location permission
//     final status = await FlutterQiblah.checkLocationStatus();

//     if (!status.enabled ||
//         status.status == LocationPermission.denied ||
//         status.status == LocationPermission.deniedForever) {
//       await FlutterQiblah.requestPermissions();
//       final newStatus = await FlutterQiblah.checkLocationStatus();
//       if (!newStatus.enabled ||
//           newStatus.status == LocationPermission.denied ||
//           newStatus.status == LocationPermission.deniedForever) {
//         return false;
//       }
//     }

//     // Check sensors (accelerometer + magnetometer)
//     return await _hasCompassSupport();
//   }

//   Future<bool> _hasCompassSupport() async {
//     bool hasAccelerometer = false;
//     bool hasMagnetometer = false;

//     final accelSub = accelerometerEvents.listen((_) {
//       hasAccelerometer = true;
//     });

//     final magnetoSub = magnetometerEvents.listen((_) {
//       hasMagnetometer = true;
//     });

//     await Future.delayed(const Duration(seconds: 1));
//     await accelSub.cancel();
//     await magnetoSub.cancel();

//     return hasAccelerometer && hasMagnetometer;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: _checkPermissionsAndSensors(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const LoadingIndicator();
//         }

//         if (snapshot.hasError || snapshot.data == false) {
//           return LocationErrorWidget(
//             error: "Location permission or compass sensor unavailable.",
//             callback: () => setState(() {}),
//           );
//         }

//         return const QiblahCompassWidget();
//       },
//     );
//   }
// }

// class QiblahCompassWidget extends StatelessWidget {
//   const QiblahCompassWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QiblahDirection>(
//       stream: FlutterQiblah.qiblahStream,
//       builder: (_, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting ||
//             !snapshot.hasData) {
//           return const LoadingIndicator();
//         }

//         final qiblahDirection = snapshot.data!;

//         return Stack(
//           alignment: Alignment.center,
//           children: <Widget>[
//             Transform.rotate(
//               angle: -(qiblahDirection.direction * (pi / 180)),
//               child: SvgPicture.asset('assets/images/compass.svg'),
//             ),
//             Transform.rotate(
//               angle: -(qiblahDirection.qiblah * (pi / 180)),
//               child: SvgPicture.asset(
//                 'assets/images/needle.svg',
//                 height: 300,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             Positioned(
//               bottom: 16,
//               child: Text(
//                 "${qiblahDirection.offset.toStringAsFixed(1)}° to Qiblah",
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
