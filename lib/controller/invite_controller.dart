import 'dart:convert';

import 'package:flutter_project_application/Model/invite.dart';

import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;

class InviteController {
  Future listInvites() async {
    // ignore: prefer_interpolation_to_compose_strings

    Map data = {};

    var url = Uri.parse(baseURL + '/invite/list');
    var body = json.encode(data);

    print(url);

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

    print(url);

    http.Response response = await http.post(url, headers: headers, body: body);

    // ignore: avoid_print
    print(response.body);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => InviteModel.fromInviteToJson(e)).toList();
  }
}
