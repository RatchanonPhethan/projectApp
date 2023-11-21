import 'dart:convert';

import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;

class ChangePasswordController {
  Future changepassword(
      String username, String password, String newpassword) async {
    Map<String, dynamic> logindata = {
      "username": username,
      "password": password,
      "newpassword": newpassword
    };

    var url = Uri.parse('$baseURL/changepassword/get');
    var body = json.encode(logindata);
    http.Response response = await http.post(url, headers: headers, body: body);

    var jsonResponse = jsonDecode(response.body);

    print("STATUS CODE LOGIN IS : ${jsonResponse["code"]}");

    return jsonResponse;
  }
}
