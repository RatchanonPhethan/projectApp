import 'dart:io';

import 'package:flutter_project_application/Model/member.dart';

import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MemberController {
  Future getMemberByUsername(String username) async {
    var url = Uri.parse('$baseURL/member/get/$username');

    http.Response response = await http.get(url);

    var jsonResponse = jsonDecode(response.body);
    MemberModel member = MemberModel.fromMemberToJson(jsonResponse['result']);
    return member;
  }

  Future getMemberById(String memberId) async {
    var url = Uri.parse('$baseURL/member/getbyid/$memberId');

    http.Response response = await http.get(url);

    var jsonResponse = jsonDecode(response.body);
    MemberModel member = MemberModel.fromMemberToJson(jsonResponse['result']);
    return member;
  }

  Future addMember(String user, String ft, String ln, String tel, String email,
      String bd, double an, String gd, String pw, String ad, File im) async {
    Map<String, dynamic> MemberData = {
      "username": user,
      "firstname": ft,
      "lastname": ln,
      "tel": tel,
      "email": email,
      "birthday": bd,
      "amountmoney": an,
      "gender": gd,
      "password": pw,
      "address": ad,
    };
    var path = await upload(im);

    MemberData["imgmember"] = path;

    var body = json.encode(MemberData);
    var addMemberurl = Uri.parse('$baseURL/member/add');

    http.Response response =
        await http.post(addMemberurl, headers: headers, body: body);
    var jsonResponse = jsonDecode(response.body);
    return response;
  }

  Future upload(File file) async {
    if (file == null) return;

    var uri = Uri.parse("$baseURL/member/upload");
    var length = await file.length();
    http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(
        http.MultipartFile('image', file.openRead(), length,
            filename: 'test.png'),
      );
    var response = await http.Response.fromStream(await request.send());
    return response.body;
  }

  Future updatestatusban(String memberId) async {
    Map data = {};

    var url = Uri.parse('$baseURL/member/updatestatusban/$memberId');

    http.Response response =
        await http.post(url, headers: headers, body: json.encode(data));
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }
}
