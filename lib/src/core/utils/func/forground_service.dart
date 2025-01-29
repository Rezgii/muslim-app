import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:muslim/src/core/utils/func/salat_task_handler.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class ForeGroundService {
  ForeGroundService._();
  static final instance = ForeGroundService._();
  final ValueNotifier<Object?> taskDataListenable = ValueNotifier(null);

  void onReceiveTaskData(Object data) {
    log('=> Received task data: $data');
    taskDataListenable.value = data;
  }

  void initCommunicationPort() {
    FlutterForegroundTask.initCommunicationPort();
  }

  void initService() async {
    await _requestPermissions();
    FlutterForegroundTask.addTaskDataCallback(onReceiveTaskData);
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Next Prayer',
        channelDescription: 'Prayer Time',
        onlyAlertOnce: true,
        channelImportance: NotificationChannelImportance.HIGH,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<void> _requestPermissions() async {
    final notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    if (Platform.isAndroid) {
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }
    }
  }

  Future<ServiceRequestResult> startService(
      String prayerName, String prayerTime, String countdown) async {
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return await FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: prayerName,
        notificationText: '${_convertTimeFormat(prayerTime)} | $countdown',
        notificationInitialRoute: '/home',
        notificationButtons: [
          const NotificationButton(
            id: 'btn_stop',
            text: 'إغلاق الإشعار',
            textColor: Colors.red,
          )
        ],
        //
        callback: startCallback,
      );
    }
  }

  String _convertTimeFormat(String inputTime) {
    // Remove spaces around the colon
    String cleanedTime = inputTime.replaceAll(' ', '');

    // Parse the input string as a DateTime object
    final parsedTime = DateTime.parse('1970-01-01 $cleanedTime');

    // Format the time using the intl package
    final formattedTime = DateFormat('hh:mm a').format(parsedTime);

    return formattedTime;
  }

  Future<ServiceRequestResult> stopService() async {
    return await FlutterForegroundTask.stopService();
  }
}

// The callback function should always be a top-level or static function.
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(SalatTaskHandler.instance);
}
