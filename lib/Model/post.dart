// ignore_for_file: non_constant_identifier_names
import 'package:flutter_project_application/model/member.dart';
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
  String shipping;
  double shipping_fee;
  List<String> img_product;
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
      required this.shipping,
      required this.shipping_fee,
      required this.img_product,
      required this.member});

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
      post_id: json["post_id"],
      post_name: json["post_name"],
      post_detail: json["post_detail"],
      member_amount: json["member_amount"],
      post_status: json["post_status"],
      start_date:
          DateFormat('MMM d, yyyy, HH:mm:ss aaa').parse(json["start_date"]),
      end_date: DateFormat('MMM d, yyyy, HH:mm:ss aaa').parse(json["end_date"]),
      product_price: json["product_price"],
      product_qty: json["product_qty"],
      productshare_qty: json["productshare_qty"],
      shipping: json["shipping"],
      shipping_fee: json["shipping_fee"],
      img_product: List<String>.from(json["img_product"]),
      member: MemberModel.fromMemberToJson(json["member_id"]));

  Map<String, dynamic> fromJson() => <String, dynamic>{
        'post_id': post_id,
        'post_name': post_name,
        'post_detail': post_detail,
        'member_amount': member_amount,
        'post_status': post_status,
        'start_date': start_date,
        'end_date': end_date,
        'product_price': product_price,
        'product_qty': product_qty,
        'productshare_qty': productshare_qty,
        'shipping': shipping,
        'shipping_fee': shipping_fee,
        'img_product': img_product,
        'member': member.fromMemberToJson()
      };
}
