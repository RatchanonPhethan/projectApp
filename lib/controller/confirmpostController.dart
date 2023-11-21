import 'dart:convert';

import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;

class ConfirmPostController {
  Future confirmpost(String postid) async {
    Map data = {};

    var url = Uri.parse('$baseURL/confirmpost/confirm/$postid');

    http.Response response =
        await http.post(url, headers: headers, body: json.encode(data));
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }
}
