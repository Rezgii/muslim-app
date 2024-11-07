// import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';

class PrayerTimeApi {
  PrayerTimeApi._();

  static final PrayerTimeApi _instance = PrayerTimeApi._();
  static PrayerTimeApi get instance => _instance;

  getPrayerTime(String latitude, String longitude, String date) async {
    final uri =
        'https://api.aladhan.com/v1/timings/$date?latitude=$latitude&longitude=$longitude&method=19&tune=0,2,1,1,0,5,5,1,0';

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
