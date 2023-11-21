import 'dart:convert';

import '../Model/post.dart';
import '../constant/constant_value.dart';

import 'package:http/http.dart' as http;

class ViewPostDetails {
  Future getVIewPostDetails(String username) async {
    var postUrl =
        Uri.parse('$baseURL/viewPostDetails/viewPostDetail/$username');

    http.Response response = await http.get(postUrl);

    print(response.body);

    var jsonResponse = json.decode(response.body);
    PostModel post = PostModel.fromJson(jsonResponse['result']);
    return post;
  }
}
