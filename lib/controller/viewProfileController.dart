import 'dart:convert';

import '../Model/member.dart';
import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;

class ViewProfileController {
  Future getViewProfile(String username) async {
    var memberUrl = Uri.parse('$baseURL/member/get/$username');

    http.Response response = await http.get(memberUrl);

    print(response.body);

    var jsonResponse = json.decode(response.body);
    MemberModel member = MemberModel.fromMemberToJson(jsonResponse['result']);
    return member;
  }
}
