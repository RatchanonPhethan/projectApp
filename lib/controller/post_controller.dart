// ignore_for_file: prefer_interpolation_to_compose_strings, duplicate_ignore, avoid_print

import 'package:flutter_project_application/Model/post.dart';

import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostController {
  //query ListAllPosts return list
  Future listAllPosts() async {
    // ignore: prefer_interpolation_to_compose_strings

    Map data = {};

    var url = Uri.parse(baseURL + '/post/list');
    var body = json.encode(data);

    print(url);

    http.Response response = await http.post(url, headers: headers, body: body);

    // ignore: avoid_print
    print(response.body);

    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => PostModel.fromJson(e)).toList();
  }

//query PostById return post
  Future getPostById(String postId) async {
    var url = Uri.parse(baseURL + '/post/get/' + postId);

    http.Response response = await http.get(url);

    print(response.body);

    var jsonResponse = jsonDecode(response.body);
    PostModel post = PostModel.fromJson(jsonResponse['result']);
    print("Controller : ${post.post_id}");
    return post;
  }

  Future removePost(String postId) async {
    Map data = {};

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/post/remove/$postId');

    http.Response response = await http.post(url, headers: headers, body: body);
    //print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }
}
