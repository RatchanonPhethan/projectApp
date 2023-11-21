import 'dart:convert';
import 'dart:io';

import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;

class EditProfileController {
  Future editMyProfile(
      String member_id,
      String username,
      bool isadmin,
      String firstname,
      String lastname,
      String tel,
      String email,
      String birthday,
      double amountmoney,
      String gender,
      String password,
      String address,
      File? imgmember,
      String oldimgpath) async {
    String user = await SessionManager().get("username");
    Map<String, dynamic> memberdata = {
      "member_id": member_id,
      "username": user,
      "isadmin": isadmin,
      "firstname": firstname,
      "lastname": lastname,
      "tel": tel,
      "email": email,
      "birthday": birthday,
      "amountmoney": amountmoney,
      "gender": gender,
      "password": password,
      "address": address,
    };
    var path;
    if (imgmember != null) {
      path = await upload(imgmember);
      memberdata["img_member"] = path;
    } else {
      memberdata["img_member"] = oldimgpath;
    }
    print(oldimgpath);
    print(path);

    var body = json.encode(memberdata);
    var editMemberurl = Uri.parse('$baseURL/editProfile/edit');

    http.Response response =
        await http.post(editMemberurl, headers: headers, body: body);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }

  Future upload(File file) async {
    if (file == null) return;

    var uri = Uri.parse("$baseURL/member/upload");
    var length = await file.length();
    http.MultipartRequest request = new http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(
        http.MultipartFile('image', file.openRead(), length,
            filename: 'test.png'),
      );
    var response = await http.Response.fromStream(await request.send());
    return response.body;
  }
}
