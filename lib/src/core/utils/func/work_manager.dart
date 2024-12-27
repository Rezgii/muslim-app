import 'dart:developer';

import 'package:muslim/src/core/utils/func/local_notification_service.dart';
import 'package:workmanager/workmanager.dart';

class WorkManagerService {
  void registerMyTask() async {
    await Workmanager().registerPeriodicTask(
      "id1",
      "adhkar reminder",
      frequency: const Duration(days: 1),
      initialDelay: const Duration(minutes: 1),
    );
  }

  //Init Work Manager Service
  Future<void> init() async {
    await Workmanager().initialize(
      actionTask,
      isInDebugMode: false,
    );
    //Register Task
    registerMyTask();
  }

  void cancelTask(String id) {
    Workmanager().cancelByUniqueName(id);
  }
}

@pragma('vm:entry-point')
void actionTask() {
  //Show Reminder
  Workmanager().executeTask((task, inputData) async {
    //The background task code goes here
    log("========Reminders========");
    LocalNotificationService.scheduledDailyNotification(
        title: 'تذكير',
        body: 'حان وقت أذكار الصباح',
        time: DateTime.now(),
        hour: 06,
        minute: 00);
    log("Scheduled Reminder At 06:00 AM");
    LocalNotificationService.scheduledDailyNotification(
        title: 'تذكير',
        body: 'حان وقت أذكار المساء',
        time: DateTime.now(),
        hour: 18,
        minute: 00);
    log("Scheduled Reminder At 06:00 PM");
    return Future.value(true);
  });
}
