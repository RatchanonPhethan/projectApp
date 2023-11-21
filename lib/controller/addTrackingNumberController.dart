import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constant/constant_value.dart';

class AddTrackingNumberController {
  Future addTrackingNumber(String paymentid, String tracking_number) async {
    Map data = {"tacking_number": tracking_number};

    var url = Uri.parse('$baseURL/addTrackingNumber/add/$paymentid');

    http.Response response =
        await http.post(url, headers: headers, body: json.encode(data));
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }
}
