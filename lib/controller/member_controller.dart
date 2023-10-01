import 'package:flutter_project_application/Model/member.dart';

import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MemberController {
  Future getMemberByUsername(String username) async {
    var url = Uri.parse(baseURL + '/member/get/' + username);

    http.Response response = await http.get(url);

    print(response.body);

    var jsonResponse = jsonDecode(response.body);
    MemberModel member = MemberModel.fromMemberToJson(jsonResponse['result']);
    print("Controller : ${member.member_id}");
    return member;
  }
}
