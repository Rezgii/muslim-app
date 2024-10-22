import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  String fullName;
  @HiveField(1)
  String phone;
  @HiveField(2)
  String email;
  @HiveField(3)
  String uid;
  UserModel({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.uid,
  });

  UserModel copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? uid,
  }) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'uid': uid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      uid: map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(fullName: $fullName, phone: $phone, email: $email, uid: $uid)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.fullName == fullName &&
        other.phone == phone &&
        other.email == email &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^ phone.hashCode ^ email.hashCode ^ uid.hashCode;
  }
}
