import 'dart:convert';
import 'dart:io';

import 'package:flutter_project_application/Model/report.dart';

import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;

class ReportController {
  Future listReportMember() async {
    // ignore: prefer_interpolation_to_compose_strings

    Map data = {};

    var url = Uri.parse(baseURL + '/report/listmember');
    var body = json.encode(data);

    print(url);

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

    var url = Uri.parse(baseURL + '/report/listpost');
    var body = json.encode(data);

    print(url);

    http.Response response = await http.post(url, headers: headers, body: body);

    // ignore: avoid_print
    print(response.body);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => ReportModel.fromJson(e)).toList();
  }

  Future addReportPost(
      String detail, String img, String username, String postId) async {
    Map data = {
      "detail": detail,
      "img_report": img,
      "report_type": "POST",
      "username": username,
      "postId": postId,
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/report/add');

    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
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

    // var path = await upload(img);

    // data["img_report"] = path;

    // print(path);
    var body = json.encode(data);
    var url = Uri.parse('$baseURL/report/add');

    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }

  // Future upload(File file) async {
  //   if (file == null) return;

  //   var uri = Uri.parse(baseURL + "/report/upload");
  //   var length = await file.length();
  //   //print(length);
  //   http.MultipartRequest request = new http.MultipartRequest('POST', uri)
  //     ..headers.addAll(headers)
  //     ..files.add(
  //       // replace file with your field name exampe: image
  //       http.MultipartFile('image', file.openRead(), length,
  //           filename: 'test.png'),
  //     );
  //   var response = await http.Response.fromStream(await request.send());
  //   //var jsonResponse = jsonDecode(response.body);
  //   return response.body;
  // }
}
