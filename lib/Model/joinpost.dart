// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';
import 'package:intl/intl.dart';

import 'member.dart';
import 'post.dart';

class JoinPostModel {
  String payment_id;
  double price;
  String pickup_status;
  String tacking_number;
  int quantity_product;
  DateTime payment_date;
  PostModel post;
  MemberModel member;
  JoinPostModel(
      {required this.payment_id,
      required this.price,
      required this.pickup_status,
      required this.tacking_number,
      required this.quantity_product,
      required this.post,
      required this.payment_date,
      required this.member});
  factory JoinPostModel.fromJoinPostToJson(Map<String, dynamic> json) =>
      JoinPostModel(
          payment_id: json["payment_id"],
          price: json["price"],
          pickup_status: json["pickup_status"],
          tacking_number: json["tacking_number"],
          quantity_product: json["quantity_product"],
          payment_date: DateFormat('MMM d, yyyy, HH:mm:ss aaa')
              .parse(json['payment_date']),
          post: PostModel.fromJson(json["post_id"]),
          member: MemberModel.fromMemberToJson(json['member_id']));

  Map<String, dynamic> fromJoinPostToJson() {
    return <String, dynamic>{
      'payment_id': payment_id,
      'price': price,
      'pickup_status': pickup_status,
      'tacking_number': tacking_number,
      'quantity_product': quantity_product,
      'payment_date': payment_date,
      'post_id': post.fromJson(),
      'member_id': member.fromMemberToJson()
    };
  }
}
