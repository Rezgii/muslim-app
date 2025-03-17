import 'dart:convert';

class IslamicEventModel {
  String event;
  int hijriDay;
  int hijriMonth;
  String monthName;
  String description;
  IslamicEventModel({
    required this.event,
    required this.hijriDay,
    required this.hijriMonth,
    required this.monthName,
    required this.description,
  });

  IslamicEventModel copyWith({
    String? event,
    int? hijriDay,
    int? hijriMonth,
    String? monthName,
    String? description,
  }) {
    return IslamicEventModel(
      event: event ?? this.event,
      hijriDay: hijriDay ?? this.hijriDay,
      hijriMonth: hijriMonth ?? this.hijriMonth,
      monthName: monthName ?? this.monthName,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'event': event,
      'hijriDay': hijriDay,
      'hijriMonth': hijriMonth,
      'monthName': monthName,
      'description': description,
    };
  }

  factory IslamicEventModel.fromMap(Map<String, dynamic> map) {
    return IslamicEventModel(
      event: map['event'] as String,
      hijriDay: map['hijriDay'] as int,
      hijriMonth: map['hijriMonth'] as int,
      monthName: map['monthName'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory IslamicEventModel.fromJson(String source) => IslamicEventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'IslamicEventModel(event: $event, hijriDay: $hijriDay, hijriMonth: $hijriMonth, monthName: $monthName, description: $description)';
  }

  @override
  bool operator ==(covariant IslamicEventModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.event == event &&
      other.hijriDay == hijriDay &&
      other.hijriMonth == hijriMonth &&
      other.monthName == monthName &&
      other.description == description;
  }

  @override
  int get hashCode {
    return event.hashCode ^
      hijriDay.hashCode ^
      hijriMonth.hashCode ^
      monthName.hashCode ^
      description.hashCode;
  }
}
