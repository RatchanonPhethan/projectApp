import 'package:flutter/material.dart';
import 'package:flutter_project_application/Screens/Home.dart';
import 'package:flutter_project_application/controller/ViewPostDetails_controller.dart';
import 'package:flutter_project_application/model/member.dart';
import 'package:flutter_project_application/widgets/MenuFooter.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../model/post.dart';
import '../styles/styles.dart';
import '../widgets/CustomSearchDelegate.dart';
import '../widgets/MenuWidget.dart';
import 'loginScreen.dart';

class ViewPostDetailPage extends StatefulWidget {
  final String? postId;
  const ViewPostDetailPage({Key? key, required this.postId}) : super(key: key);

  @override
  State<ViewPostDetailPage> createState() => _ViewPostDetailPage();
}

class _ViewPostDetailPage extends State<ViewPostDetailPage> {
  PostModel? post;
  bool? isDataLoaded = false;

  final ViewPostDetails viewPostDetails = ViewPostDetails();

  void fetchPost(String postId) async {
    post = await viewPostDetails.getVIewPostDetails(postId);
    print(post?.post_id);
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPost(widget.postId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: Text(
          "Home",
          style: TextStyle(color: KFontColor),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon: Icon(Icons.search))
        ],
      ),
      drawer: const MenuWidget(),
      body: isDataLoaded == false
          ? CircularProgressIndicator()
          : Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: [
                Text("${post?.post_name}"),
                Text("ราคา ${post?.product_price} บาท"),
                const Text("รายละเอียด"),
                Text("${post?.post_detail}"),
                Text("สินค้าที่เหลือ: ${post?.productshare_qty}"),
                Text("การจัดส่งสินค้า: ${post?.shipping}"),
                Text("ค่าจัดส่ง: ${post?.shipping_fee} บาท"),
                Text("วันที่ปิดรับการเข้าร่วม: ${post?.end_date}"),
                Text("${post?.post_status} 0/${post?.member_amount}"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {}, child: const Text("ขอเข้าร่วม")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: ((BuildContext context) {
                            return const MainPage();
                          })));
                        },
                        child: const Text("ปิด"))
                  ],
                ),
              ]),
            ),
    );
  }
}
