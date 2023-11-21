import 'dart:convert';

import '../Model/post.dart';
import '../constant/constant_value.dart';

import 'package:http/http.dart' as http;

class SearchPostController {
  var data = [];
  List? list;
  Future searchPost({String? query}) async {
    var searchPostUrl = Uri.parse("$baseURL/search/searchPost");
    http.Response response = await http.get(searchPostUrl);
    print("querycon: ${query}");
    try {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      list = mapResponse['result'];
      list = list!.map((e) => PostModel.fromJson(e)).toList();
      DateTime currentDate = DateTime.now();

      list = list?.where((post) {
        DateTime postDate = post.end_date;

        return postDate.isAfter(currentDate);
      }).toList();

      if (query != null) {
        list = list
            ?.where((element) =>
                element.post_name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    } on Exception catch (e) {
      print(e);
    }
    print("listback: ${list}");
    return list;
  }

  Future serachpost(String searchword) async {
    var url = Uri.parse('$baseURL/search/searchPost/$searchword');

    http.Response response = await http.get(url);

    Map<String, dynamic> mapResponse = json.decode(response.body);
    list = mapResponse['result'];
    list = list!.map((e) => PostModel.fromJson(e)).toList();

    return list;
  }
}
