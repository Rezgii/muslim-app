import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TimeLine extends Equatable {
  final bool active;
  final Timestamp timestamp;
  const TimeLine({
    required this.active,
    required this.timestamp,
  });

  TimeLine copyWith({
    bool? active,
    Timestamp? timestamp,
  }) {
    return TimeLine(
      active: active ?? this.active,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'active': active,
      'timestamp': timestamp,
    };
  }

  factory TimeLine.fromMap(Map<String, dynamic> map) {
    return TimeLine(
      active: map['active'] as bool,
      timestamp: map['timestamp'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeLine.fromJson(String source) =>
      TimeLine.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [active, timestamp];
}