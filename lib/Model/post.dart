// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_project_application/Model/member.dart';
import 'package:intl/intl.dart';

class PostModel {
  String post_id;
  String post_name;
  String post_detail;
  int member_amount;
  String post_status;
  DateTime start_date;
  DateTime end_date;
  double product_price;
  int product_qty;
  int productshare_qty;
  List<String> img_product;
  String shipping;
  double shipping_fee;
  MemberModel member;
  PostModel(
      {required this.post_id,
      required this.post_name,
      required this.post_detail,
      required this.member_amount,
      required this.post_status,
      required this.start_date,
      required this.end_date,
      required this.product_price,
      required this.product_qty,
      required this.productshare_qty,
      required this.img_product,
      required this.shipping,
      required this.shipping_fee,
      required this.member});

  Map<String, dynamic> fromJson() {
    return <String, dynamic>{
      'post_id': post_id,
      'post_name': post_name,
      'post_detail': post_detail,
      'member_amount': member_amount,
      'post_status': post_status,
      'start_date': start_date.millisecondsSinceEpoch,
      'end_date': end_date.millisecondsSinceEpoch,
      'product_price': product_price,
      'product_qty': product_qty,
      'productshare_qty': productshare_qty,
      'img_product': img_product,
      'shipping': shipping,
      'shipping_fee': shipping_fee,
      'member_id': member.fromMemberToJson()
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> map) {
    return PostModel(
        post_id: map['post_id'] as String,
        post_name: map['post_name'] as String,
        post_detail: map['post_detail'] as String,
        member_amount: map['member_amount'] as int,
        post_status: map['post_status'] as String,
        start_date: DateFormat('MMM d, yyyy').parse(map['start_date']),
        end_date: DateFormat('MMM d, yyyy').parse(map['end_date']),
        product_price: map['product_price'] as double,
        product_qty: map['product_qty'] as int,
        productshare_qty: map['productshare_qty'] as int,
        img_product: List<String>.from((map['img_product'] as List)),
        shipping: map['shipping'] as String,
        shipping_fee: map['shipping_fee'] as double,
        member: MemberModel.fromMemberToJson(map['member_id']));
  }
}
