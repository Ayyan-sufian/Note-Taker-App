
import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';
@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  String userName;
  @HiveField(1)
  String userId;
  @HiveField(2)
  String? userToken;
  @HiveField(3)
  int age;
  @HiveField(4)
  String email;
  @HiveField(5)
  String password;

  UserModel({
    required this.userId,
    required this.userToken,
    required this.userName,
    required this.age,
    required this.email,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json,
      String id,) {
    return UserModel(
      userId: id,
      userName: json['userName'] ?? '',
      userToken: json['userToken'],
      age: json['age'] ?? 0,
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': userName,
      'age': age,
      'email': email,
      'userToken': userToken,
    };
  }
}