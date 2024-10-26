// import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';

class PrayerTimeByAddressApi {
  PrayerTimeByAddressApi._();

  static final PrayerTimeByAddressApi _instance = PrayerTimeByAddressApi._();
  static PrayerTimeByAddressApi get instance => _instance;

  getPrayerTime(String address, String date) async {
    final uri =
        'https://api.aladhan.com/v1/timingsByAddress/$date?address=$address';

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
