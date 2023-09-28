// ignore_for_file: non_constant_identifier_names

import 'package:flutter_project_application/Model/member.dart';
import 'package:flutter_project_application/Model/post.dart';
import 'package:intl/intl.dart';

class InviteModel {
  String invite_id;
  DateTime invite_date;
  String status;
  PostModel post;
  MemberModel member;

  InviteModel({
    required this.invite_id,
    required this.invite_date,
    required this.status,
    required this.post,
    required this.member,
  });

  factory InviteModel.fromInviteToJson(Map<String, dynamic> json) =>
      InviteModel(
          invite_id: json["invite_id"] as String,
          invite_date: DateFormat('MMM d, yyyy, HH:mm:ss aaa')
              .parse(json['invite_date']),
          status: json["status"] as String,
          post: PostModel.fromJson(json["post_id"]),
          member: MemberModel.fromMemberToJson(json['member_id']));

  Map<String, dynamic> fromInviteToJson() {
    return <String, dynamic>{
      'invite_id': invite_id,
      'invite_date': invite_date,
      'status': status,
      'post_id': post.fromJson(),
      'member_id': member.fromMemberToJson()
    };
  }
}
