// ignore_for_file: unused_local_variable

import 'package:flutter_project_application/Model/joinpost.dart';

import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JoinPostController {
  Future listJoinPosts() async {
    // ignore: prefer_interpolation_to_compose_strings

    Map data = {};

    var url = Uri.parse('$baseURL/join/list');
    var body = json.encode(data);

    http.Response response = await http.post(url, headers: headers, body: body);

    // ignore: avoid_print
    print(response.body);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => JoinPostModel.fromJoinPostToJson(e)).toList();
  }

  Future getJoinPostById(String postId) async {
    var url = Uri.parse('$baseURL/join/get/$postId');

    http.Response response = await http.get(url);

    var jsonResponse = jsonDecode(response.body);
    JoinPostModel joinpost =
        JoinPostModel.fromJoinPostToJson(jsonResponse['result']);
    return joinpost;
  }

  Future getJoinPostByPostId(String postId) async {
    Map data = {};
    var url = Uri.parse('$baseURL/join/listmember/$postId');
    var body = json.encode(data);
    http.Response response = await http.post(url, headers: headers, body: body);
    List? list;
    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => JoinPostModel.fromJoinPostToJson(e)).toList();
  }

  Future confirmReceiveProduct(String paymentId) async {
    var url = Uri.parse('$baseURL/join/confirm/$paymentId');
    http.Response response = await http.get(url);
  }

  Future listJoinPostsByMember(String memberId) async {
    // ignore: prefer_interpolation_to_compose_strings

    Map data = {};

    var url = Uri.parse('$baseURL/join/getmember/$memberId');
    var body = json.encode(data);

    http.Response response = await http.post(url, headers: headers, body: body);

    // ignore: avoid_print
    print(response.body);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => JoinPostModel.fromJoinPostToJson(e)).toList();
  }

  Future addJoinPost(String quantityProduct, String username, String postId,
      String price) async {
    Map data = {
      "quantity_product": quantityProduct,
      "username": username,
      "postId": postId,
      "price": price
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/join/add');

    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
  }

  Future conFirmInvite(String quantityProduct, String username, String postId,
      String price, String inviteId) async {
    print(inviteId);
    Map data = {
      "quantity_product": quantityProduct,
      "username": username,
      "postId": postId,
      "price": price,
      "inviteId": inviteId
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/join/confirminvite');

    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
  }

  Future listJoinMember(String postId) async {
    // ignore: prefer_interpolation_to_compose_strings

    Map data = {};

    var url = Uri.parse('$baseURL/join/listmember/$postId');
    var body = json.encode(data);

    http.Response response = await http.post(url, headers: headers, body: body);

    // ignore: avoid_print
    print(response.body);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => JoinPostModel.fromJoinPostToJson(e)).toList();
  }

  Future leaveGroup(String postId) async {
    Map data = {};

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/join/remove/$postId');

    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
  }

  Future memberCount(String postId) async {
    Map data = {
      "postId": postId,
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/join/membercount');

    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    int? str;
    Map<String, dynamic> mapResponse = json.decode(response.body);
    str = mapResponse['result'];
    return str;
  }

  Future joinCount(String username, String postId) async {
    Map data = {"postId": postId, "username": username};
    var body = json.encode(data);
    var url = Uri.parse('$baseURL/join/joincount');

    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    int? str;
    Map<String, dynamic> mapResponse = json.decode(response.body);
    str = mapResponse['result'];
    return str;
  }
}
