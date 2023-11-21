// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Model/login.dart';
import '../constant/constant_value.dart';

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

  Future Login(String username, String password) async {
    Map<String, dynamic> logindata = {
      "username": username,
      "password": password
    };

    var url = Uri.parse('$baseURL/login/get');
    var body = json.encode(logindata);
    http.Response response = await http.post(url, headers: headers, body: body);

    var jsonResponse = jsonDecode(response.body);

    print("STATUS CODE LOGIN IS : ${jsonResponse["code"]}");

    return jsonResponse;
  }

  Future LoginByUsernameandPassword(String username, String password) async {
    Map<String, dynamic> logindata = {
      "username": username,
      "password": password,
    };
    var url = Uri.parse(baseURL + '/login/get');

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
