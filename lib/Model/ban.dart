// ignore_for_file: non_constant_identifier_names

import 'package:flutter_project_application/Model/member.dart';
import 'package:intl/intl.dart';

class BanModel {
  String ban_id;
  String ban_detail;
  DateTime start_date;
  DateTime end_date;
  MemberModel member;

  BanModel(
      {required this.ban_id,
      required this.ban_detail,
      required this.start_date,
      required this.end_date,
      required this.member});
  factory BanModel.fromBanToJson(Map<String, dynamic> json) => BanModel(
      ban_id: json["ban_id"],
      ban_detail: json["ban_detail"],
      start_date:
          DateFormat('MMM d, yyyy, HH:mm:ss aaa').parse(json['start_date']),
      end_date: DateFormat('MMM d, yyyy, HH:mm:ss aaa').parse(json['end_date']),
      member: MemberModel.fromMemberToJson(json['member_id']));

  Map<String, dynamic> fromBanToJson() {
    return <String, dynamic>{
      'ban_id': ban_id,
      'ban_detail': ban_detail,
      'start_date': start_date,
      'end_date': end_date,
      'member_id': member.fromMemberToJson()
    };
  }
}
