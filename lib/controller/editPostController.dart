import 'dart:convert';
import 'dart:io';

import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;

class EditPostController {
  Future editMyPost(
    List<File> imgproduct,
    List<String> oldimgpoduct,
    String post_id,
    String postName,
    String postDetail,
    double price,
    String postStatus,
    String startDate,
    String endDate,
    String shipping,
    double shippingFee,
    int memberAmount,
    int productQty,
    int productShareQty,
  ) async {
    String user = await SessionManager().get("username");
    Map<String, dynamic> postData = {
      "post_id": post_id,
      "postname": postName,
      "postdetail": postDetail,
      "productprice": price,
      "post_status": postStatus,
      "start_date": startDate,
      "end_date": endDate,
      "shipping": shipping,
      "shippingfee": shippingFee,
      "memberamount": memberAmount,
      "productqty": productQty,
      "productshareqty": productShareQty,
      "username": user
    };
    List<String> path = [];
    if (imgproduct.isNotEmpty && oldimgpoduct.isNotEmpty) {
      for (int index = 0; index < imgproduct.length; index++) {
        String imgpath = await upload(imgproduct.elementAt(index));
        path.add(imgpath);
      }
      for (int index = 0; index < oldimgpoduct.length; index++) {
        path.add(oldimgpoduct.elementAt(index));
      }
    } else if (oldimgpoduct.isNotEmpty) {
      for (int index = 0; index < oldimgpoduct.length; index++) {
        path.add(oldimgpoduct.elementAt(index));
      }
    } else {
      for (int index = 0; index < imgproduct.length; index++) {
        String imgpath = await upload(imgproduct.elementAt(index));
        path.add(imgpath);
      }
    }

    String imgarray = path.toString();
    postData["img_product"] = imgarray;
    var body = json.encode(postData);
    var postUrl = Uri.parse('$baseURL/editPost/edit');

    http.Response response =
        await http.post(postUrl, headers: headers, body: body);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }

  Future upload(File file) async {
    if (file == null) return;

    var uri = Uri.parse("$baseURL/post/upload");
    var length = await file.length();
    http.MultipartRequest request = new http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(
        http.MultipartFile('image', file.openRead(), length,
            filename: 'test.png'),
      );
    var response = await http.Response.fromStream(await request.send());
    return response.body;
  }
}
