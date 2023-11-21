import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Model/post.dart';
import '../constant/constant_value.dart';

class ListMyPostController {
  Future getLisyMyPost(String username) async {
    var postUrl = Uri.parse("$baseURL/post/listMyPost/$username");

    http.Response response = await http.get(postUrl);
    print(response.body);
    List? list;

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    return list!.map((e) => PostModel.fromJson(e)).toList();
  }
}
