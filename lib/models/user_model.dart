
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
}
