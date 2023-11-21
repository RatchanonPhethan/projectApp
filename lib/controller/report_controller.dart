import 'dart:convert';
import 'dart:io';

import 'package:flutter_project_application/Model/report.dart';

import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;

class ReportController {
  Future listReportMember() async {
    // ignore: prefer_interpolation_to_compose_strings

    Map data = {};

    var url = Uri.parse('$baseURL/report/listmember');
    var body = json.encode(data);

    http.Response response = await http.post(url, headers: headers, body: body);

    // ignore: avoid_print
    print(response.body);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => ReportModel.fromJson(e)).toList();
  }

  Future listReportPost() async {
    // ignore: prefer_interpolation_to_compose_strings

    Map data = {};

    var url = Uri.parse('$baseURL/report/listpost');
    var body = json.encode(data);

    http.Response response = await http.post(url, headers: headers, body: body);

    // ignore: avoid_print
    print(response.body);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => ReportModel.fromJson(e)).toList();
  }

  Future addReportPost(File img, String detail, String img_report,
      String username, String postId) async {
    Map data = {
      "detail": detail,
      "img_report": img_report,
      "report_type": "POST",
      "username": username,
      "postId": postId,
    };
    var path = await upload(img);

    data["img_report"] = path;

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/report/add');

    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
  }

  Future addReportMember(File img, String detail, String img_report,
      String username, String postId) async {
    Map data = {
      "detail": detail,
      "img_report": img_report,
      "report_type": "MEMBER",
      "username": username,
      "postId": postId,
    };

    var path = await upload(img);

    data["img_report"] = path;

    // print(path);
    var body = json.encode(data);
    var url = Uri.parse('$baseURL/report/add');

    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
  }

  Future upload(File file) async {
    if (file == null) return;
    var uri = Uri.parse("$baseURL/report/upload");
    var length = await file.length();
    //print(length);
    http.MultipartRequest request = new http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(
        // replace file with your field name exampe: image
        http.MultipartFile('image', file.openRead(), length,
            filename: 'test.png'),
      );
    var response = await http.Response.fromStream(await request.send());
    //var jsonResponse = jsonDecode(response.body);
    return response.body;
  }

  Future getListReportPostById(String postId) async {
    var url = Uri.parse('$baseURL/report/getlistpost/$postId');
    Map data = {};
    var body = json.encode(data);
    http.Response response = await http.post(url, headers: headers, body: body);
    // ignore: avoid_print
    print(response.body);
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => ReportModel.fromJson(e)).toList();
  }

  Future getListReportMemberById(String memberId) async {
    var url = Uri.parse('$baseURL/report/getlistmember/$memberId');
    Map data = {};
    var body = json.encode(data);
    http.Response response = await http.post(url, headers: headers, body: body);
    // ignore: avoid_print
    print(response.body);
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => ReportModel.fromJson(e)).toList();
  }

  Future reportPostCount(String postId) async {
    Map data = {};
    var body = json.encode(data);
    var url = Uri.parse('$baseURL/report/getcountpost/$postId');
    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    int? str;
    Map<String, dynamic> mapResponse = json.decode(response.body);
    str = mapResponse['result'];
    return str;
  }

  Future reportMemberCount(String memberId, String postId) async {
    Map data = {"postId": postId};
    var body = json.encode(data);
    var url = Uri.parse('$baseURL/report/getcountmember/$memberId');
    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    int? str;
    Map<String, dynamic> mapResponse = json.decode(response.body);
    str = mapResponse['result'];
    return str;
  }

  Future removeReportMemberById(String memberId) async {
    Map data = {};
    var body = json.encode(data);
    var url = Uri.parse('$baseURL/report/removereportmember/$memberId');
    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
  }

  Future removeReportPostById(String postId) async {
    Map data = {};
    var body = json.encode(data);
    var url = Uri.parse('$baseURL/report/removereportpost/$postId');
    http.Response response = await http.post(url, headers: headers, body: body);
    final urls = Uri.https(
        'flutter-project-sharehub-default-rtdb.asia-southeast1.firebasedatabase.app',
        'chat/$postId.json');

    final responses = await http.delete(urls);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
  }
}
