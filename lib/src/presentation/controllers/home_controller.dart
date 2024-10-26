import 'package:get/get.dart';
import 'package:muslim/src/data/models/prayer_time_model.dart';

class HomeController extends GetxController {
  final PrayerTimeModel prayersTime = Get.arguments['prayersTime'];

}
