// ignore_for_file: non_constant_identifier_names

import 'package:flutter_project_application/Model/login.dart';

import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginController {
  Future LoginByUsername(String username) async {
    var url = Uri.parse(baseURL + '/login/get/' + username);

    http.Response response = await http.get(url);

    print(response.body);

    var jsonResponse = jsonDecode(response.body);
    if (response.body.toString() == '{"code":200}') {
      LoginModel login = LoginModel(username: "", password: "", isadmin: false);
      return login;
    } else {
      LoginModel login = LoginModel.fromLoginToJson(jsonResponse['result']);
      print("Controller : ${login.username}");
      return login;
    }
  }
}
