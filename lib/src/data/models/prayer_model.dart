// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class PrayerModel extends Equatable {
  final String timeImage;
  final String prayerName;
  final String prayerTime;
  final String soundIcon;
  const PrayerModel({
    required this.timeImage,
    required this.prayerName,
    required this.prayerTime,
    required this.soundIcon,
  });

  PrayerModel copyWith({
    String? timeImage,
    String? prayerName,
    String? prayerTime,
    String? soundIcon,
  }) {
    return PrayerModel(
      timeImage: timeImage ?? this.timeImage,
      prayerName: prayerName ?? this.prayerName,
      prayerTime: prayerTime ?? this.prayerTime,
      soundIcon: soundIcon ?? this.soundIcon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'timeImage': timeImage,
      'prayerName': prayerName,
      'prayerTime': prayerTime,
      'soundIcon': soundIcon,
    };
  }

  factory PrayerModel.fromMap(Map<String, dynamic> map) {
    return PrayerModel(
      timeImage: map['timeImage'] as String,
      prayerName: map['prayerName'] as String,
      prayerTime: map['prayerTime'] as String,
      soundIcon: map['soundIcon'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PrayerModel.fromJson(String source) =>
      PrayerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [timeImage, prayerName, prayerTime, soundIcon];
}
