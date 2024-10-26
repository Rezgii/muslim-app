// import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';

class CurrentDateApi {
  CurrentDateApi._();

  static final CurrentDateApi _instance = CurrentDateApi._();
  static CurrentDateApi get instance => _instance;

  Future<String> getDate(String zone) async {
    final uri = 'https://api.aladhan.com/v1/currentDate?zone=$zone';

    Response<dynamic> response = await Dio().get(
      uri,
      options: Options(
        responseType: ResponseType.json,
      ),
    );

    if (response.statusCode == 200) {
      return response.data['data'];
    } else if (response.statusCode == 500) {
      return '';
    } else {
      throw Exception("Some Error Happened");
    }
  }
}
