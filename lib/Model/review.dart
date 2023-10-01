// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:flutter_project_application/Model/joinpost.dart';
import 'package:intl/intl.dart';

class ReviewModel {
  String review_id;
  double score;
  String comment;
  DateTime review_date;
  JoinPostModel payment_id;
  ReviewModel(
      {required this.review_id,
      required this.score,
      required this.comment,
      required this.review_date,
      required this.payment_id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'review_id': review_id,
      'score': score,
      'comment': comment,
      'review_date': review_date,
      'payment_id': payment_id.fromJoinPostToJson()
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
        review_id: map['review_id'],
        score: map['score'],
        comment: map['comment'],
        review_date:
            DateFormat('MMM d, yyyy, HH:mm:ss aaa').parse(map['review_date']),
        payment_id: JoinPostModel.fromJoinPostToJson(map['payment_id']));
  }
}
