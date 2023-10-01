// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LoginModel {
  String username;
  String password;
  bool isadmin;
  LoginModel({
    required this.username,
    required this.password,
    required this.isadmin,
  });

  Map<String, dynamic> fromLoginToJson() {
    return <String, dynamic>{
      'username': username,
      'password': password,
      'isadmin': isadmin,
    };
  }

  factory LoginModel.fromLoginToJson(Map<String, dynamic> map) {
    return LoginModel(
      username: map['username'],
      password: map['password'],
      isadmin: map['isadmin'] as bool,
    );
  }
}
