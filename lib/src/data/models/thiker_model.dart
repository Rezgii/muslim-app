// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ThikerModel extends Equatable {
  String thiker;
  int repeat;
  ThikerModel({
    required this.thiker,
    required this.repeat,
  });

  ThikerModel copyWith({
    String? thiker,
    int? repeat,
  }) {
    return ThikerModel(
      thiker: thiker ?? this.thiker,
      repeat: repeat ?? this.repeat,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'thiker': thiker,
      'repeat': repeat,
    };
  }

  factory ThikerModel.fromMap(Map<String, dynamic> map) {
    return ThikerModel(
      thiker: map['thiker'] as String,
      repeat: map['repeat'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ThikerModel.fromJson(String source) => ThikerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [thiker, repeat];
}
