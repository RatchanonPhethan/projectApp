import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Model/ban.dart';
import '../constant/constant_value.dart';

class BanController {
  Future addBanMember(String detail, String endDate, String memberId) async {
    Map data = {
      "detail": detail,
      "end_date": endDate,
      "memberId": memberId,
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/ban/add');

    http.Response response = await http.post(url, headers: headers, body: body);
    var jsonResponse = jsonDecode(response.body);
  }

  Future getBanByMemberId(String memberId) async {
    var url = Uri.parse('$baseURL/ban/get/$memberId');

    http.Response response = await http.get(url);

    print(response.body);

    var jsonResponse = jsonDecode(response.body);
    BanModel ban = BanModel.fromBanToJson(jsonResponse['result']);
    print("Controller : ${ban.ban_id}");
    return ban;
  }
}
