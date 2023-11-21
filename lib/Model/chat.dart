// ignore_for_file: non_constant_identifier_names

import 'package:flutter_project_application/Model/member.dart';
import 'package:flutter_project_application/Model/post.dart';
import 'package:intl/intl.dart';

class ChatModel {
  String chat_id;
  DateTime time;
  String text;
  MemberModel member;

  ChatModel({
    required this.chat_id,
    required this.time,
    required this.text,
    required this.member,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chat_id': chat_id,
      'time': time,
      'text': text,
      'member': member.fromMemberToJson(),
    };
  }

  factory ChatModel.toMap(Map<String, dynamic> json) => ChatModel(
        chat_id: json["chat_id"],
        time: DateFormat('MMM d, yyyy, HH:mm:ss aaa').parse(json['time']),
        text: json["text"],
        member: MemberModel.fromMemberToJson(json['member_id']),
      );
}
