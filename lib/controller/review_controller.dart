import 'package:flutter_project_application/Model/review.dart';

import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewController {
  Future ViewMemberReview(String memberId) async {
    // ignore: prefer_interpolation_to_compose_strings

    Map data = {};

    var url = Uri.parse('$baseURL/review/listmember/$memberId');
    var body = json.encode(data);

    print(url);

    http.Response response = await http.post(url, headers: headers, body: body);

    // ignore: avoid_print
    print(response.body);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];

    return list!.map((e) => ReviewModel.fromMap(e)).toList();
  }

  Future addReviewMember(String score, String comment, String postId) async {
    Map data = {
      "score": score,
      "comment": comment,
      "postId": postId,
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/review/add');

    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }

  Future reviewCount(String paymentId, String memberId) async {
    Map data = {
      "memberId": memberId,
      "paymentId": paymentId,
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/review/counts');

    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    int? str;
    Map<String, dynamic> mapResponse = json.decode(response.body);
    str = mapResponse['result'];
    print(jsonResponse);
    return str;
  }
}
