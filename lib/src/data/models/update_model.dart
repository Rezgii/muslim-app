import 'dart:convert';


class UpdateModel {
  String title;
  String description;
  UpdateModel({
    required this.title,
    required this.description,
  });

  UpdateModel copyWith({
    String? title,
    String? description,
  }) {
    return UpdateModel(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
    };
  }

  factory UpdateModel.fromMap(Map<String, dynamic> map) {
    return UpdateModel(
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateModel.fromJson(String source) =>
      UpdateModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UpdateModel(title: $title, description: $description)';

  @override
  bool operator ==(covariant UpdateModel other) {
    if (identical(this, other)) return true;

    return other.title == title && other.description == description;
  }

  @override
  int get hashCode => title.hashCode ^ description.hashCode;
}
