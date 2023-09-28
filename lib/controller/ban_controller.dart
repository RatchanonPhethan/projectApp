import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constant/constant_value.dart';

class BanController {
  Future addBanMember(String detail, String endDate, String username) async {
    Map data = {
      "detail": detail,
      "end_date": endDate,
      "username": username,
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/ban/add');

    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }
}
