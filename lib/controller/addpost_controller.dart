import 'dart:convert';
import 'dart:io';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../Model/post.dart';
import '../constant/constant_value.dart';

//Add Post
// ignore: camel_case_types
class addPostController {
  Future addPost(
      List<File> imgproduct,
      String postname,
      String postdetail,
      double productprice,
      String end_date,
      String shipping,
      double shippingfee,
      int memberamount,
      int productqty,
      int productshareqty) async {
    String user = await SessionManager().get("username");
    print(user.toString());
    List<String> path = [];
    Map<String, dynamic> postData = {
      "postname": postname,
      "postdetail": postdetail,
      "productprice": productprice,
      "end_date": end_date,
      "shipping": shipping,
      "shippingfee": shippingfee,
      "memberamount": memberamount,
      "productqty": productqty,
      "productshareqty": productshareqty,
      "username": user
    };
    for (int index = 0; index < imgproduct.length; index++) {
      String imgpath = await upload(imgproduct.elementAt(index));
      path.add(imgpath);
    }

    String imgarray = path.toString();
    postData["img_product"] = imgarray;

    var body = json.encode(postData);
    var postUrl = Uri.parse('$baseURL/addpost/add');

    http.Response response =
        await http.post(postUrl, headers: headers, body: body);
    print(response.body);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    return response;
  }

  Future upload(File file) async {
    // ignore: unnecessary_null_comparison
    if (file == null) return;
    var uri = Uri.parse("$baseURL/post/upload");
    var length = await file.length();
    http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(
        http.MultipartFile('image', file.openRead(), length,
            filename: 'test.png'),
      );
    var response = await http.Response.fromStream(await request.send());
    return response.body;
  }

  //List All Post
  Future getListAllPost() async {
    var postUrl = Uri.parse('$baseURL/post/list');
    http.Response response = await http.get(postUrl);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => PostModel.fromJson(e)).toList();
  }

  Future getListOtherPost(String username) async {
    var postUrl = Uri.parse('$baseURL/post/listNotMyPost/$username');

    http.Response response = await http.get(postUrl);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => PostModel.fromJson(e)).toList();
  }
}
