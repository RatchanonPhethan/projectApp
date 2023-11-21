// ignore_for_file: non_constant_identifier_names

import 'package:flutter_project_application/Model/login.dart';
import 'package:intl/intl.dart';

class MemberModel {
  String member_id;
  String firstname;
  String lastname;
  String tel;
  String email;
  DateTime birthday;
  double amount_money;
  String gender;
  String address;
  String img_member;
  bool member_status;
  LoginModel login;
  MemberModel({
    required this.member_id,
    required this.firstname,
    required this.lastname,
    required this.tel,
    required this.email,
    required this.birthday,
    required this.amount_money,
    required this.gender,
    required this.address,
    required this.img_member,
    required this.member_status,
    required this.login,
  });

  Map<String, dynamic> fromMemberToJson() {
    return <String, dynamic>{
      'member_id': member_id,
      'firstname': firstname,
      'lastname': lastname,
      'tel': tel,
      'email': email,
      'birthday': birthday,
      'amount_money': amount_money,
      'gender': gender,
      'address': address,
      'img_member': img_member,
      'member_status': member_status,
      'login': login.fromLoginToJson(),
    };
  }

  factory MemberModel.fromMemberToJson(Map<String, dynamic> map) {
    return MemberModel(
      member_id: map['member_id'] as String,
      firstname: map['firstname'] as String,
      lastname: map['lastname'] as String,
      tel: map['tel'] as String,
      email: map['email'] as String,
      birthday: DateFormat('MMM d, yyyy, HH:mm:ss aaa').parse(map['birthday']),
      amount_money: map['amount_money'] as double,
      gender: map['gender'] as String,
      address: map['address'] as String,
      img_member: map['img_member'] as String,
      member_status: map['member_status'] as bool,
      login: LoginModel.fromLoginToJson(map['username']),
    );
  }
}
