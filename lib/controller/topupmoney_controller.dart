import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constant/constant_value.dart';

class TopUpMoneyController {
  Future topUpMoney(String memberid, double amountMoney) async {
    Map data = {"amount_money": amountMoney};

    var url = Uri.parse('$baseURL/money/topup/$memberid');

    http.Response response =
        await http.post(url, headers: headers, body: json.encode(data));
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }
}
