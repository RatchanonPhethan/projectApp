import 'dart:convert';

import 'package:flutter_project_application/Model/invite.dart';

import '../Model/review.dart';
import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;

class InviteController {
  Future listInvites() async {
    // ignore: prefer_interpolation_to_compose_strings

    Map data = {};

    var url = Uri.parse(baseURL + '/invite/list');
    var body = json.encode(data);

    http.Response response = await http.post(url, headers: headers, body: body);

    // ignore: avoid_print
    print(response.body);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => InviteModel.fromInviteToJson(e)).toList();
  }

  Future listInvitesByMember(String memberId) async {
    // ignore: prefer_interpolation_to_compose_strings

    Map data = {};

    var url = Uri.parse(baseURL + '/invite/listmember/$memberId');
    var body = json.encode(data);

    http.Response response = await http.post(url, headers: headers, body: body);

    // ignore: avoid_print
    print(response.body);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => InviteModel.fromInviteToJson(e)).toList();
  }

  Future removeInvite(String inviteId) async {
    Map data = {};

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/invite/remove/$inviteId');
    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
  }

  Future addInvite(String post_id, String member_id) async {
    Map data = {"post_id": post_id, "member_id": member_id};

    var url = Uri.parse('$baseURL/invite/add');

    http.Response response =
        await http.post(url, headers: headers, body: json.encode(data));
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }

  Future dolistInvitesByMember(String memberId) async {
    Map data = {};

    var url = Uri.parse('$baseURL/invite/listinvite/$memberId');
    var body = json.encode(data);

    print(url);
    http.Response response = await http.get(url);

    print(response.body);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => ReviewModel.fromMap(e)).toList();
  }

  Future checkInvite(String memberId, String postId) async {
    Map<String, dynamic> invitedata = {
      "member_id": memberId,
      "post_id": postId
    };

    var url = Uri.parse('$baseURL/invite/getcheck');
    var body = json.encode(invitedata);
    http.Response response = await http.post(url, headers: headers, body: body);

    Map<String, dynamic> mapResponse = json.decode(response.body);
    int check = mapResponse["result"];

    return check;
  }
}
