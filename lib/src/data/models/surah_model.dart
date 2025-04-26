// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class SurahModel {
  int number;
  Map<dynamic, dynamic> name;
  Map<dynamic, dynamic> place;
  int versesCount;
  int wordsCount;
  int lettersCount;
  List<Map<dynamic, dynamic>> verses;

  SurahModel({
    required this.number,
    required this.name,
    required this.place,
    required this.versesCount,
    required this.wordsCount,
    required this.lettersCount,
    required this.verses,
  });

  SurahModel copyWith({
    int? number,
    Map<dynamic, dynamic>? name,
    Map<dynamic, dynamic>? place,
    int? versesCount,
    int? wordsCount,
    int? lettersCount,
    List<Map<dynamic, dynamic>>? verses,
  }) {
    return SurahModel(
      number: number ?? this.number,
      name: name ?? this.name,
      place: place ?? this.place,
      versesCount: versesCount ?? this.versesCount,
      wordsCount: wordsCount ?? this.wordsCount,
      lettersCount: lettersCount ?? this.lettersCount,
      verses: verses ?? this.verses,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'number': number,
      'name': name,
      'place': place,
      'versesCount': versesCount,
      'wordsCount': wordsCount,
      'lettersCount': lettersCount,
      'verses': verses,
    };
  }

  factory SurahModel.fromMap(Map<dynamic, dynamic> map) {
    return SurahModel(
      number: map['number'] as int,
      name: Map<dynamic, dynamic>.from((map['name'] as Map<dynamic, dynamic>)),
      place: Map<dynamic, dynamic>.from((map['revelation_place'] as Map<dynamic, dynamic>)),
      versesCount: map['verses_count'] as int,
      wordsCount: map['words__count'] as int,
      lettersCount: map['letters__count'] as int,
      verses: List<Map<dynamic, dynamic>>.from(
        (map['verses'] as List<Map<dynamic, dynamic>>).map<Map<dynamic, dynamic>>(
          (x) => x,
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SurahModel.fromJson(String source) =>
      SurahModel.fromMap(json.decode(source) as Map<dynamic, dynamic>);

  @override
  String toString() {
    return 'SurahModel(number: $number, name: $name, place: $place, versesCount: $versesCount, wordsCount: $wordsCount, lettersCount: $lettersCount, verses: $verses)';
  }

  @override
  bool operator ==(covariant SurahModel other) {
    if (identical(this, other)) return true;

    return other.number == number &&
        mapEquals(other.name, name) &&
        mapEquals(other.place, place) &&
        other.versesCount == versesCount &&
        other.wordsCount == wordsCount &&
        other.lettersCount == lettersCount &&
        listEquals(other.verses, verses);
  }

  @override
  int get hashCode {
    return number.hashCode ^
        name.hashCode ^
        place.hashCode ^
        versesCount.hashCode ^
        wordsCount.hashCode ^
        lettersCount.hashCode ^
        verses.hashCode;
  }
}
