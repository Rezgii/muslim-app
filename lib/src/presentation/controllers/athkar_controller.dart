import 'package:get/get.dart';
import 'package:muslim/src/core/utils/const/athkar_data.dart';
import 'package:muslim/src/data/models/thiker_model.dart';

class AthkarController extends GetxController {
  List<ThikerModel> athkar = [];
  String title = Get.arguments['title'];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments['type'] == 'morning') {
      athkar.addAll(morning
          .map(
              (item) => item.copyWith(thiker: item.thiker, repeat: item.repeat))
          .toList());
    } else if (Get.arguments['type'] == 'evening') {
      athkar.addAll(evening
          .map(
              (item) => item.copyWith(thiker: item.thiker, repeat: item.repeat))
          .toList());
    } else if (Get.arguments['type'] == 'wakeup') {
      athkar.addAll(wakeup
          .map(
              (item) => item.copyWith(thiker: item.thiker, repeat: item.repeat))
          .toList());
    } else if (Get.arguments['type'] == 'sleep') {
      athkar.addAll(sleep
          .map(
              (item) => item.copyWith(thiker: item.thiker, repeat: item.repeat))
          .toList());
    } else if (Get.arguments['type'] == 'praying') {
      athkar.addAll(praying
          .map(
              (item) => item.copyWith(thiker: item.thiker, repeat: item.repeat))
          .toList());
    }
  }
}
