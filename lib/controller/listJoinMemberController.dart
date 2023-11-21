import 'dart:convert';

import 'package:flutter_project_application/model/joinpost.dart';
import 'package:http/http.dart' as http;

import '../constant/constant_value.dart';

class ListJoinMemberController {
  Future getListJoinMember(String post) async {
    var postUrl = Uri.parse("$baseURL/listjoinmember/listJoinMember/$post");

    http.Response response = await http.get(postUrl);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => JoinPostModel.fromJoinPostToJson(e)).toList();
  }
}
