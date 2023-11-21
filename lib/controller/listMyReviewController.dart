import 'dart:convert';

import 'package:flutter_project_application/model/review.dart';
import 'package:http/http.dart' as http;

import '../constant/constant_value.dart';

class ListMyReviewController {
  Future ListMyReview(String memberId) async {
    Map data = {};

    var url = Uri.parse('$baseURL/review/listmyreview/$memberId');
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
}
