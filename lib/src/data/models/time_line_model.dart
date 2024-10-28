import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TimeLine extends Equatable {
  final String prayerName;
  final Timestamp timestamp;
  const TimeLine({
    required this.prayerName,
    required this.timestamp,
  });

  TimeLine copyWith({
    String? prayerName,
    Timestamp? timestamp,
  }) {
    return TimeLine(
      prayerName: prayerName ?? this.prayerName,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'prayerName': prayerName,
      'timestamp': timestamp,
    };
  }

  factory TimeLine.fromMap(Map<String, dynamic> map) {
    return TimeLine(
      prayerName: map['prayerName'] as String,
      timestamp: map['timestamp'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeLine.fromJson(String source) =>
      TimeLine.fromMap(json.decode(source) as Map<String, dynamic>);


  @override
  List<Object> get props => [prayerName, timestamp];
}