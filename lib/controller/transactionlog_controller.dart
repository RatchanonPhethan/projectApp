import 'package:flutter_project_application/Model/transactionlog.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionLogController {
  Future addLog(
      double amount, String logdetails, String postid, String memberid) async {
    String user = await SessionManager().get("username");
    print(user.toString());
    List<String> path = [];
    Map<String, dynamic> logData = {
      "amount": amount,
      "log_details": logdetails,
      "postId": postid,
      "memberId": memberid,
    };

    var body = json.encode(logData);
    var postUrl = Uri.parse('$baseURL/log/add');

    http.Response response =
        await http.post(postUrl, headers: headers, body: body);
    print(response.body);
    var jsonResponse = jsonDecode(response.body);
  }

  Future listLogsByMember(String memberId) async {
    // ignore: prefer_interpolation_to_compose_strings

    Map data = {};

    var url = Uri.parse('$baseURL/log/listmember/$memberId');
    var body = json.encode(data);

    print(url);

    http.Response response = await http.post(url, headers: headers, body: body);

    // ignore: avoid_print
    print(response.body);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => TransactionLogModel.fromJson(e)).toList();
  }

  Future removeLogById(String logId) async {
    Map data = {};
    var body = json.encode(data);
    var url = Uri.parse('$baseURL/log/remove/$logId');
    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
  }

  Future removeLogByMemberId(String memberId) async {
    Map data = {};
    var body = json.encode(data);
    var url = Uri.parse('$baseURL/log/removebymember/$memberId');
    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
  }
}
