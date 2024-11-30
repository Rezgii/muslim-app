// import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';

class PrayerTimeCalendarApi {
  PrayerTimeCalendarApi._();

  static final PrayerTimeCalendarApi _instance = PrayerTimeCalendarApi._();
  static PrayerTimeCalendarApi get instance => _instance;

  getPrayerTimeCalendar(String latitude, String longitude, String year) async {
    final uri =
        'https://api.aladhan.com/v1/calendar/$year?latitude=$latitude&longitude=$longitude&method=19&tune=0,2,1,1,0,5,5,1,0';

    Response<dynamic> response = await Dio().get(
      uri,
      options: Options(
        responseType: ResponseType.json,
      ),
    );

    if (response.statusCode == 200) {
      return response.data['data'];
    } else if (response.statusCode == 500) {
      return null;
    } else {
      throw Exception("Some Error Happened");
    }
  }
}
