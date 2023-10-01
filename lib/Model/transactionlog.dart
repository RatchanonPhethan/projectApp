// ignore_for_file: non_constant_identifier_names

import 'package:flutter_project_application/Model/member.dart';
import 'package:flutter_project_application/Model/post.dart';
import 'package:intl/intl.dart';

class TransactionLogModel {
  String transaction_id;
  DateTime log_date;
  String log_detail;
  double amount;
  PostModel post;
  MemberModel member;

  TransactionLogModel(
      {required this.transaction_id,
      required this.log_date,
      required this.log_detail,
      required this.amount,
      required this.post,
      required this.member});

  Map<String, dynamic> fromJson() {
    return <String, dynamic>{
      'transaction_id': transaction_id,
      'log_date': log_date,
      'log_detail': log_detail,
      'amount': amount,
      'post_id': post.fromJson(),
      'member_id': member.fromMemberToJson()
    };
  }

  factory TransactionLogModel.fromJson(Map<String, dynamic> map) {
    return TransactionLogModel(
        transaction_id: map['transaction_id'],
        log_date:
            DateFormat('MMM d, yyyy, HH:mm:ss aaa').parse(map['log_date']),
        log_detail: map['log_detail'],
        amount: map['amount'],
        post: PostModel.fromJson(map['post_id']),
        member: MemberModel.fromMemberToJson(map['member_id']));
  }
}
