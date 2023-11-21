import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RemovePostController {
  Future removePost(String postId) async {
    Map data = {};

    var body = json.encode(data);
    var url = Uri.parse('$baseURL/removePost/remove/$postId');

    final urls = Uri.https(
        'flutter-project-sharehub-default-rtdb.asia-southeast1.firebasedatabase.app',
        'chat/$postId.json');

    final responses = await http.delete(urls);

    http.Response response = await http.post(url, headers: headers, body: body);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }
}
