import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PrayerTimeModel {
  Map<String, dynamic> prayersTime;
  Map<String, dynamic> date;
  PrayerTimeModel({
    required this.prayersTime,
    required this.date,
  });

  PrayerTimeModel copyWith({
    Map<String, dynamic>? prayersTime,
    Map<String, dynamic>? date,
  }) {
    return PrayerTimeModel(
      prayersTime: prayersTime ?? this.prayersTime,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'prayersTime': prayersTime,
      'date': date,
    };
  }

  factory PrayerTimeModel.fromMap(Map<dynamic, dynamic> map) {
    return PrayerTimeModel(
      prayersTime: Map<String, dynamic>.from((map['timings'] as Map<dynamic, dynamic>)),
      date: Map<String, dynamic>.from((map['date'] as Map<dynamic, dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory PrayerTimeModel.fromJson(String source) => PrayerTimeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PrayerTimeModel(prayersTime: $prayersTime, date: $date)';

  @override
  bool operator ==(covariant PrayerTimeModel other) {
    if (identical(this, other)) return true;
  
    return 
      mapEquals(other.prayersTime, prayersTime) &&
      mapEquals(other.date, date);
  }

  @override
  int get hashCode => prayersTime.hashCode ^ date.hashCode;
}
